# UUVPN GitHub Secrets 配置脚本 (PowerShell)
# 用于快速配置 GitHub Actions 所需的 Secrets

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "UUVPN GitHub Secrets 配置工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否安装了 GitHub CLI
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Host "❌ 错误: 未安装 GitHub CLI" -ForegroundColor Red
    Write-Host "请先安装 GitHub CLI: https://cli.github.com/"
    exit 1
}

# 检查是否已登录 GitHub
try {
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ 错误: 未登录 GitHub CLI" -ForegroundColor Red
        Write-Host "请先运行: gh auth login"
        exit 1
    }
} catch {
    Write-Host "❌ 错误: 未登录 GitHub CLI" -ForegroundColor Red
    Write-Host "请先运行: gh auth login"
    exit 1
}

# 获取仓库信息
try {
    $remoteUrl = git remote get-url origin
    if ($remoteUrl -match "github\.com[:/](.+?)\.git") {
        $repo = $matches[1]
    } else {
        Write-Host "❌ 错误: 无法获取仓库信息" -ForegroundColor Red
        Write-Host "请确保在仓库目录中运行此脚本"
        exit 1
    }
} catch {
    Write-Host "❌ 错误: 无法获取仓库信息" -ForegroundColor Red
    Write-Host "请确保在仓库目录中运行此脚本"
    exit 1
}

Write-Host "✅ 当前仓库: $repo" -ForegroundColor Green
Write-Host ""

# 配置 Android Secrets
Write-Host "📱 配置 Android Secrets" -ForegroundColor Yellow
Write-Host "----------------------------------------"

$configAndroid = Read-Host "是否配置 Android 签名密钥? (y/n)"
if ($configAndroid -eq "y") {
    $keystorePath = Read-Host "密钥库文件路径 (默认: release.keystore)"
    if ([string]::IsNullOrWhiteSpace($keystorePath)) {
        $keystorePath = "release.keystore"
    }

    if (-not (Test-Path $keystorePath)) {
        Write-Host "❌ 错误: 密钥库文件不存在: $keystorePath" -ForegroundColor Red
        Write-Host "请先创建密钥库:"
        Write-Host "keytool -genkey -v -keystore release.keystore -alias uuvpn -keyalg RSA -keysize 2048 -validity 10000"
        exit 1
    }

    $keystorePassword = Read-Host "密钥库密码" -AsSecureString
    $keystorePasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($keystorePassword)
    )

    $keyAlias = Read-Host "密钥别名 (默认: uuvpn)"
    if ([string]::IsNullOrWhiteSpace($keyAlias)) {
        $keyAlias = "uuvpn"
    }

    $keyPassword = Read-Host "密钥密码" -AsSecureString
    $keyPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($keyPassword)
    )

    # Base64 编码密钥库
    $keystoreBytes = [IO.File]::ReadAllBytes($keystorePath)
    $keystoreBase64 = [Convert]::ToBase64String($keystoreBytes)

    Write-Host "正在设置 Android Secrets..." -ForegroundColor Cyan
    $keystoreBase64 | gh secret set ANDROID_KEYSTORE_BASE64 --repo $repo
    $keystorePasswordPlain | gh secret set ANDROID_KEYSTORE_PASSWORD --repo $repo
    $keyAlias | gh secret set ANDROID_KEY_ALIAS --repo $repo
    $keyPasswordPlain | gh secret set ANDROID_KEY_PASSWORD --repo $repo

    Write-Host "✅ Android Secrets 配置完成" -ForegroundColor Green
}

Write-Host ""

# 配置 iOS Secrets
Write-Host "🍎 配置 iOS Secrets" -ForegroundColor Yellow
Write-Host "----------------------------------------"

$configIOS = Read-Host "是否配置 iOS 签名证书? (y/n)"
if ($configIOS -eq "y") {
    $certPath = Read-Host "证书文件路径 (.p12)"

    if (-not (Test-Path $certPath)) {
        Write-Host "❌ 错误: 证书文件不存在: $certPath" -ForegroundColor Red
        exit 1
    }

    $certPassword = Read-Host "证书密码" -AsSecureString
    $certPasswordPlain = [Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($certPassword)
    )

    $teamId = Read-Host "Team ID"
    $signingIdentity = Read-Host "签名身份 (如: Apple Distribution: Your Name (TEAM_ID))"

    $profilePath = Read-Host "Provisioning Profile 文件路径 (.mobileprovision)"

    if (-not (Test-Path $profilePath)) {
        Write-Host "❌ 错误: Provisioning Profile 文件不存在: $profilePath" -ForegroundColor Red
        exit 1
    }

    # Base64 编码
    $certBytes = [IO.File]::ReadAllBytes($certPath)
    $certBase64 = [Convert]::ToBase64String($certBytes)

    $profileBytes = [IO.File]::ReadAllBytes($profilePath)
    $profileBase64 = [Convert]::ToBase64String($profileBytes)

    Write-Host "正在设置 iOS Secrets..." -ForegroundColor Cyan
    $certBase64 | gh secret set IOS_CERTIFICATES_P12 --repo $repo
    $certPasswordPlain | gh secret set IOS_CERTIFICATES_PASSWORD --repo $repo
    $teamId | gh secret set IOS_TEAM_ID --repo $repo
    $signingIdentity | gh secret set IOS_SIGNING_IDENTITY --repo $repo
    $profileBase64 | gh secret set IOS_PROVISIONING_PROFILE --repo $repo

    Write-Host "✅ iOS Secrets 配置完成" -ForegroundColor Green
}

Write-Host ""

# 配置 App Store Connect Secrets
Write-Host "🚀 配置 App Store Connect Secrets" -ForegroundColor Yellow
Write-Host "----------------------------------------"

$configASC = Read-Host "是否配置 App Store Connect API? (y/n)"
if ($configASC -eq "y") {
    $issuerId = Read-Host "Issuer ID"
    $apiKeyId = Read-Host "API Key ID"
    $p8Path = Read-Host "API Private Key 文件路径 (.p8)"

    if (-not (Test-Path $p8Path)) {
        Write-Host "❌ 错误: API Private Key 文件不存在: $p8Path" -ForegroundColor Red
        exit 1
    }

    # 读取私钥内容
    $apiKey = Get-Content $p8Path -Raw

    Write-Host "正在设置 App Store Connect Secrets..." -ForegroundColor Cyan
    $issuerId | gh secret set APP_STORE_CONNECT_ISSUER_ID --repo $repo
    $apiKeyId | gh secret set APP_STORE_CONNECT_API_KEY_ID --repo $repo
    $apiKey | gh secret set APP_STORE_CONNECT_API_PRIVATE_KEY --repo $repo

    Write-Host "✅ App Store Connect Secrets 配置完成" -ForegroundColor Green
}

Write-Host ""

# 配置通知 Secrets
Write-Host "📢 配置通知 Secrets" -ForegroundColor Yellow
Write-Host "----------------------------------------"

$configTelegram = Read-Host "是否配置 Telegram 通知? (y/n)"
if ($configTelegram -eq "y") {
    $botToken = Read-Host "Bot Token"
    $chatId = Read-Host "Chat ID"

    Write-Host "正在设置 Telegram Secrets..." -ForegroundColor Cyan
    $botToken | gh secret set TELEGRAM_BOT_TOKEN --repo $repo
    $chatId | gh secret set TELEGRAM_CHAT_ID --repo $repo

    Write-Host "✅ Telegram Secrets 配置完成" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "✅ 配置完成!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "当前配置的 Secrets:"
gh secret list --repo $repo
Write-Host ""
Write-Host "下一步:" -ForegroundColor Yellow
Write-Host "1. 推送代码到仓库触发构建"
Write-Host "2. 查看构建状态: https://github.com/$repo/actions"
Write-Host ""