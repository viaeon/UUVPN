#!/bin/bash

# UUVPN GitHub Secrets 配置脚本
# 用于快速配置 GitHub Actions 所需的 Secrets

set -e

echo "========================================"
echo "UUVPN GitHub Secrets 配置工具"
echo "========================================"
echo ""

# 检查是否安装了 GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "❌ 错误: 未安装 GitHub CLI"
    echo "请先安装 GitHub CLI: https://cli.github.com/"
    exit 1
fi

# 检查是否已登录 GitHub
if ! gh auth status &> /dev/null; then
    echo "❌ 错误: 未登录 GitHub CLI"
    echo "请先运行: gh auth login"
    exit 1
fi

# 获取仓库信息
REPO=$(git remote get-url origin | sed -E 's|.*github\.com[:/](.*)\.git|\1|')
if [ -z "$REPO" ]; then
    echo "❌ 错误: 无法获取仓库信息"
    echo "请确保在仓库目录中运行此脚本"
    exit 1
fi

echo "✅ 当前仓库: $REPO"
echo ""

# 配置 Android Secrets
echo "📱 配置 Android Secrets"
echo "----------------------------------------"

read -p "是否配置 Android 签名密钥? (y/n): " config_android
if [ "$config_android" = "y" ]; then
    read -p "密钥库文件路径 (默认: release.keystore): " keystore_path
    keystore_path=${keystore_path:-"release.keystore"}

    if [ ! -f "$keystore_path" ]; then
        echo "❌ 错误: 密钥库文件不存在: $keystore_path"
        echo "请先创建密钥库:"
        echo "keytool -genkey -v -keystore release.keystore -alias uuvpn -keyalg RSA -keysize 2048 -validity 10000"
        exit 1
    fi

    read -sp "密钥库密码: " keystore_password
    echo ""
    read -p "密钥别名 (默认: uuvpn): " key_alias
    key_alias=${key_alias:-"uuvpn"}
    read -sp "密钥密码: " key_password
    echo ""

    # Base64 编码密钥库
    keystore_base64=$(base64 -i "$keystore_path")

    echo "正在设置 Android Secrets..."
    gh secret set ANDROID_KEYSTORE_BASE64 --repo "$REPO" --body "$keystore_base64"
    gh secret set ANDROID_KEYSTORE_PASSWORD --repo "$REPO" --body "$keystore_password"
    gh secret set ANDROID_KEY_ALIAS --repo "$REPO" --body "$key_alias"
    gh secret set ANDROID_KEY_PASSWORD --repo "$REPO" --body "$key_password"

    echo "✅ Android Secrets 配置完成"
fi

echo ""

# 配置 iOS Secrets
echo "🍎 配置 iOS Secrets"
echo "----------------------------------------"

read -p "是否配置 iOS 签名证书? (y/n): " config_ios
if [ "$config_ios" = "y" ]; then
    read -p "证书文件路径 (.p12): " cert_path

    if [ ! -f "$cert_path" ]; then
        echo "❌ 错误: 证书文件不存在: $cert_path"
        exit 1
    fi

    read -sp "证书密码: " cert_password
    echo ""
    read -p "Team ID: " team_id
    read -p "签名身份 (如: Apple Distribution: Your Name (TEAM_ID)): " signing_identity

    read -p "Provisioning Profile 文件路径 (.mobileprovision): " profile_path

    if [ ! -f "$profile_path" ]; then
        echo "❌ 错误: Provisioning Profile 文件不存在: $profile_path"
        exit 1
    fi

    # Base64 编码
    cert_base64=$(base64 -i "$cert_path")
    profile_base64=$(base64 -i "$profile_path")

    echo "正在设置 iOS Secrets..."
    gh secret set IOS_CERTIFICATES_P12 --repo "$REPO" --body "$cert_base64"
    gh secret set IOS_CERTIFICATES_PASSWORD --repo "$REPO" --body "$cert_password"
    gh secret set IOS_TEAM_ID --repo "$REPO" --body "$team_id"
    gh secret set IOS_SIGNING_IDENTITY --repo "$REPO" --body "$signing_identity"
    gh secret set IOS_PROVISIONING_PROFILE --repo "$REPO" --body "$profile_base64"

    echo "✅ iOS Secrets 配置完成"
fi

echo ""

# 配置 App Store Connect Secrets
echo "🚀 配置 App Store Connect Secrets"
echo "----------------------------------------"

read -p "是否配置 App Store Connect API? (y/n): " config_asc
if [ "$config_asc" = "y" ]; then
    read -p "Issuer ID: " issuer_id
    read -p "API Key ID: " api_key_id
    read -p "API Private Key 文件路径 (.p8): " p8_path

    if [ ! -f "$p8_path" ]; then
        echo "❌ 错误: API Private Key 文件不存在: $p8_path"
        exit 1
    fi

    # 读取私钥内容
    api_private_key=$(cat "$p8_path")

    echo "正在设置 App Store Connect Secrets..."
    gh secret set APP_STORE_CONNECT_ISSUER_ID --repo "$REPO" --body "$issuer_id"
    gh secret set APP_STORE_CONNECT_API_KEY_ID --repo "$REPO" --body "$api_key_id"
    gh secret set APP_STORE_CONNECT_API_PRIVATE_KEY --repo "$REPO" --body "$api_private_key"

    echo "✅ App Store Connect Secrets 配置完成"
fi

echo ""

# 配置通知 Secrets
echo "📢 配置通知 Secrets"
echo "----------------------------------------"

read -p "是否配置 Telegram 通知? (y/n): " config_telegram
if [ "$config_telegram" = "y" ]; then
    read -p "Bot Token: " bot_token
    read -p "Chat ID: " chat_id

    echo "正在设置 Telegram Secrets..."
    gh secret set TELEGRAM_BOT_TOKEN --repo "$REPO" --body "$bot_token"
    gh secret set TELEGRAM_CHAT_ID --repo "$REPO" --body "$chat_id"

    echo "✅ Telegram Secrets 配置完成"
fi

echo ""
echo "========================================"
echo "✅ 配置完成!"
echo "========================================"
echo ""
echo "当前配置的 Secrets:"
gh secret list --repo "$REPO"
echo ""
echo "下一步:"
echo "1. 推送代码到仓库触发构建"
echo "2. 查看构建状态: https://github.com/$REPO/actions"
echo ""