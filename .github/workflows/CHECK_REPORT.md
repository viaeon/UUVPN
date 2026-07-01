# CI/CD 配置检查报告

## ✅ 检查完成

已完成对 GitHub Actions CI/CD 配置文件的全面检查。

---

## 📁 已创建的文件

| 文件 | 路径 | 说明 |
|------|------|------|
| build.yml | `.github/workflows/build.yml` | 主工作流配置文件 |
| README.md | `.github/workflows/README.md` | 详细配置说明文档 |
| QUICKSTART.md | `.github/workflows/QUICKSTART.md` | 快速入门指南 |
| setup-secrets.sh | `.github/workflows/setup-secrets.sh` | macOS/Linux 配置脚本 |
| setup-secrets.ps1 | `.github/workflows/setup-secrets.ps1` | Windows 配置脚本 |

---

## 🔧 已修复的问题

### 问题 1: iOS 签名身份 Secret 名称不一致
- **位置**: build.yml 第 218 行
- **问题**: 使用了 `IOS_SIGNING_identity` (小写 identity)
- **修复**: 改为 `IOS_SIGNING_IDENTITY` (全大写,符合命名规范)

### 问题 2: 条件判断过于复杂
- **位置**: 多处
- **问题**: 使用了 `startsWith(github.ref, 'refs/tags/v') || github.event.inputs.release_type == 'release'` 复杂条件
- **修复**: 简化为 `startsWith(github.ref, 'refs/tags/v')`,只在创建标签时触发 Release 构建

---

## ✅ 配置验证清单

### 工作流触发条件
- ✅ Push 到 main 分支 - 触发构建
- ✅ Push 到 develop 分支 - 触发 Debug 构建
- ✅ Pull Request - 触发 Debug 构建
- ✅ 创建版本标签 (v*) - 触发 Release 构建
- ✅ 手动触发 - 可选择构建平台和类型

### Android 构建步骤
- ✅ 检出代码和子模块
- ✅ 安装 JDK 11
- ✅ 安装 Go 1.23
- ✅ 安装 Android SDK
- ✅ 创建 local.properties
- ✅ 配置签名密钥 (Release)
- ✅ 构建 APK
- ✅ 上传构建产物

### iOS 构建步骤
- ✅ 检出代码和子模块
- ✅ 安装 Xcode 15.0
- ✅ 安装开发者证书 (Release)
- ✅ 安装 Provisioning Profile (Release)
- ✅ 解析 Swift Package 依赖
- ✅ 构建 Debug 版本 (模拟器)
- ✅ 构建并归档 Release 版本
- ✅ 导出 IPA
- ✅ 上传构建产物

### 发布步骤
- ✅ 下载 Android APK
- ✅ 下载 iOS IPA
- ✅ 创建 GitHub Release
- ✅ 上传文件到 Release
- ✅ 上传到 TestFlight (Beta 和正式版)
- ✅ 发送 Telegram 通知
- ✅ 清理旧的构建产物

---

## ⚠️ 使用前必须配置的 Secrets

### Android 构建 (发布版本必需)

| Secret 名称 | 说明 | 如何获取 |
|------------|------|---------|
| `ANDROID_KEYSTORE_BASE64` | 签名密钥库的 Base64 编码 | 使用 base64 命令转换 |
| `ANDROID_KEYSTORE_PASSWORD` | 密钥库密码 | 创建密钥库时设置 |
| `ANDROID_KEY_ALIAS` | 密钥别名 | 创建密钥库时设置 |
| `ANDROID_KEY_PASSWORD` | 密钥密码 | 创建密钥库时设置 |

**注意**: Debug 构建不需要配置这些 Secrets。

### iOS 构建 (发布版本必需)

| Secret 名称 | 说明 | 如何获取 |
|------------|------|---------|
| `IOS_CERTIFICATES_P12` | 开发者证书的 Base64 编码 | 从钥匙串导出 .p12 文件 |
| `IOS_CERTIFICATES_PASSWORD` | 证书密码 | 导出时设置 |
| `IOS_TEAM_ID` | Apple Team ID | Apple Developer 账号 |
| `IOS_SIGNING_IDENTITY` | 签名身份 | 如: "Apple Distribution: Name (TEAM_ID)" |
| `IOS_PROVISIONING_PROFILE` | Provisioning Profile 的 Base64 编码 | Apple Developer 网站下载 |

**注意**: Debug 构建不需要配置这些 Secrets。

### TestFlight 上传 (可选)

| Secret 名称 | 说明 | 如何获取 |
|------------|------|---------|
| `APP_STORE_CONNECT_ISSUER_ID` | Issuer ID | App Store Connect API Keys |
| `APP_STORE_CONNECT_API_KEY_ID` | API Key ID | 创建 API Key 时获得 |
| `APP_STORE_CONNECT_API_PRIVATE_KEY` | API 私钥 | 下载的 .p8 文件内容 |

### 通知 (可选)

| Secret 名称 | 说明 | 如何获取 |
|------------|------|---------|
| `TELEGRAM_BOT_TOKEN` | Bot Token | 通过 @BotFather 创建 |
| `TELEGRAM_CHAT_ID` | Chat ID | 邀请 Bot 后获取 |

---

## 🚀 快速开始步骤

### 1. 配置 Secrets

**Windows 用户**:
```powershell
cd D:\Code\UUVPN\.github\workflows
.\setup-secrets.ps1
```

**macOS/Linux 用户**:
```bash
cd /path/to/UUVPN/.github/workflows
chmod +x setup-secrets.sh
./setup-secrets.sh
```

### 2. 推送代码测试

```bash
# 推送到 develop 分支触发 Debug 构建
git checkout -b develop
git push origin develop

# 查看 Actions 页面确认构建成功
```

### 3. 创建发布版本

```bash
# 创建 Alpha 版本
git tag v1.0.0-alpha
git push origin v1.0.0-alpha

# 创建 Beta 版本 (会自动上传到 TestFlight)
git tag v1.0.0-beta
git push origin v1.0.0-beta

# 创建正式版本
git tag v1.0.0
git push origin v1.0.0
```

---

## 📊 预期行为

### Debug 构建 (develop 分支或 PR)

**Android**:
- ✅ 使用 Debug 签名
- ✅ 构建 `app-meta-alpha-debug.apk`
- ✅ 上传到 Artifacts (保留 30 天)

**iOS**:
- ✅ 无签名
- ✅ 构建模拟器版本
- ✅ 上传 .app 文件到 Artifacts (保留 7 天)

### Release 构建 (创建标签)

**Android**:
- ✅ 使用自定义签名密钥
- ✅ 构建 Release APK
- ✅ 重命名为 `UUVPN-Android-v1.0.0.apk`
- ✅ 上传到 GitHub Release

**iOS**:
- ✅ 使用开发者证书签名
- ✅ 导出 IPA 文件
- ✅ 重命名为 `UUVPN-iOS-v1.0.0.ipa`
- ✅ 上传到 GitHub Release
- ✅ Beta 和正式版上传到 TestFlight

---

## ⏱️ 预计构建时间

| 平台 | Debug 构建 | Release 构建 |
|------|-----------|-------------|
| Android | 5-10 分钟 | 10-15 分钟 |
| iOS | 15-20 分钟 | 20-30 分钟 |

**总计**: 完整构建约 25-45 分钟

---

## 💰 成本估算

GitHub Actions 免费账户每月 2000 分钟:

| 构建类型 | 消耗时间 | 每月可构建次数 |
|---------|---------|--------------|
| 仅 Android | ~10 分钟 | ~200 次 |
| 仅 iOS | ~200 分钟 (按 10 倍计) | ~10 次 |
| Android + iOS | ~210 分钟 | ~9 次 |

**建议**: 节省 macOS runner 时间,只在需要时构建 iOS 版本。

---

## 🎯 下一步行动

1. ✅ **配置 Secrets**
   - 使用配置脚本或手动配置
   - 至少配置 Debug 构建所需的 Secrets

2. ✅ **测试 Debug 构建**
   - 推送代码到 develop 分支
   - 确认构建成功

3. ✅ **配置发布 Secrets**
   - 配置 Android 签名密钥
   - 配置 iOS 证书和 Profile

4. ✅ **创建第一个版本**
   - 创建标签触发 Release 构建
   - 验证 GitHub Release 创建成功

5. ✅ **配置 TestFlight** (可选)
   - 配置 App Store Connect API Keys
   - 验证自动上传到 TestFlight

---

## 📞 获取帮助

如遇到问题,请查看:

1. [GitHub Actions 日志](https://github.com/你的用户名/UUVPN/actions)
2. [配置文档](.github/workflows/README.md)
3. [快速入门](.github/workflows/QUICKSTART.md)
4. [项目 Issues](https://github.com/nicolastinkl/UUVPN/issues)

---

**配置检查完成! 🎉**