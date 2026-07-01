# GitHub Actions CI/CD 配置说明

本文档说明如何配置和使用 UUVPN 的 GitHub Actions 自动构建流程。

---

## 📋 目录

- [功能特性](#功能特性)
- [前置要求](#前置要求)
- [配置 Secrets](#配置-secrets)
- [使用方法](#使用方法)
- [构建产物](#构建产物)
- [自定义配置](#自定义配置)
- [常见问题](#常见问题)

---

## 功能特性

### ✅ 自动构建

- **Android APK**: 支持 Debug 和 Release 构建
- **iOS IPA**: 支持 Debug 和 Release 构建
- **多架构支持**: Android 支持 armeabi-v7a, arm64-v8a, x86, x86_64

### ✅ 自动发布

- **GitHub Releases**: 自动创建 Release 并上传构建产物
- **TestFlight**: 自动上传 iOS 版本到 TestFlight
- **Telegram 通知**: 构建完成后发送通知

### ✅ 触发条件

- 推送到 main/develop 分支
- 创建版本标签 (v*)
- Pull Request
- 手动触发

---

## 前置要求

### Android 构建

1. **JDK 11**: 已在 Actions 中自动配置
2. **Android SDK**: 已在 Actions 中自动配置
3. **Go 1.23**: 用于编译核心库
4. **签名密钥**: Release 构建需要签名密钥库

### iOS 构建

1. **Apple Developer 账号**: $99/年
2. **Xcode 15.0+**: 已在 Actions 中自动配置
3. **开发者证书**: .p12 格式
4. **Provisioning Profile**: .mobileprovision 文件
5. **App Store Connect API Key**: 用于上传到 TestFlight

---

## 配置 Secrets

在 GitHub 仓库中配置以下 Secrets:

### Android Secrets

| Secret 名称 | 描述 | 获取方式 |
|------------|------|---------|
| `ANDROID_KEYSTORE_BASE64` | 签名密钥库的 Base64 编码 | 见下方说明 |
| `ANDROID_KEYSTORE_PASSWORD` | 密钥库密码 | 创建密钥库时设置 |
| `ANDROID_KEY_ALIAS` | 密钥别名 | 创建密钥库时设置 |
| `ANDROID_KEY_PASSWORD` | 密钥密码 | 创建密钥库时设置 |

**生成 ANDROID_KEYSTORE_BASE64**:

```bash
# 在本地执行
keytool -genkey -v -keystore release.keystore -alias uuvpn -keyalg RSA -keysize 2048 -validity 10000

# 转换为 Base64
base64 -i release.keystore -o release.keystore.base64

# 或者使用 PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("release.keystore")) | Out-File release.keystore.base64
```

### iOS Secrets

| Secret 名称 | 描述 | 获取方式 |
|------------|------|---------|
| `IOS_CERTIFICATES_P12` | 开发者证书的 Base64 编码 | 见下方说明 |
| `IOS_CERTIFICATES_PASSWORD` | 证书密码 | 导出证书时设置 |
| `IOS_SIGNING_IDENTITY` | 签名身份 | 如: "Apple Distribution: Your Name (TEAM_ID)" |
| `IOS_PROVISIONING_PROFILE` | Provisioning Profile 的 Base64 编码 | 见下方说明 |
| `IOS_TEAM_ID` | Apple Team ID | 在 Apple Developer 账号中查看 |

**生成 IOS_CERTIFICATES_P12**:

1. 在 Keychain Access 中导出证书
2. 选择 "Apple Distribution" 证书
3. 右键 → 导出 → 选择 .p12 格式
4. 设置密码
5. 转换为 Base64:

```bash
base64 -i certificate.p12 -o certificate.p12.base64

# 或者使用 PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("certificate.p12")) | Out-File certificate.p12.base64
```

**生成 IOS_PROVISIONING_PROFILE**:

1. 在 Apple Developer 网站下载 Provisioning Profile
2. 转换为 Base64:

```bash
base64 -i uuvpn.mobileprovision -o uuvpn.mobileprovision.base64

# 或者使用 PowerShell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("uuvpn.mobileprovision")) | Out-File uuvpn.mobileprovision.base64
```

### App Store Connect Secrets

| Secret 名称 | 描述 | 获取方式 |
|------------|------|---------|
| `APP_STORE_CONNECT_ISSUER_ID` | App Store Connect API Issuer ID | 在 App Store Connect 中创建 API Key |
| `APP_STORE_CONNECT_API_KEY_ID` | App Store Connect API Key ID | 创建 API Key 时获得 |
| `APP_STORE_CONNECT_API_PRIVATE_KEY` | App Store Connect API 私钥 | 创建 API Key 时下载的 .p8 文件内容 |

**获取方式**:

1. 登录 [App Store Connect](https://appstoreconnect.apple.com/)
2. 进入 Users and Access → Keys
3. 点击 "Generate API Key"
4. 选择 "App Manager" 权限
5. 下载 .p8 文件并保存私钥内容

### 通知 Secrets (可选)

| Secret 名称 | 描述 | 获取方式 |
|------------|------|---------|
| `TELEGRAM_BOT_TOKEN` | Telegram Bot Token | 通过 @BotFather 创建 Bot |
| `TELEGRAM_CHAT_ID` | Telegram 群组/频道 ID | 邀请 Bot 到群组后获取 |

**获取方式**:

1. 在 Telegram 中找到 @BotFather
2. 发送 `/newbot` 创建新 Bot
3. 获取 Bot Token
4. 创建群组或频道,邀请 Bot
5. 获取 Chat ID: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`

---

## 使用方法

### 方法一: 自动触发

#### 推送到分支

```bash
# 推送到 main 分支,触发构建
git push origin main

# 推送到 develop 分支,触发 Debug 构建
git push origin develop
```

#### 创建版本标签

```bash
# 创建 Alpha 版本
git tag v1.0.0-alpha
git push origin v1.0.0-alpha

# 创建 Beta 版本
git tag v1.0.0-beta
git push origin v1.0.0-beta

# 创建正式版本
git tag v1.0.0
git push origin v1.0.0
```

#### Pull Request

创建 Pull Request 到 main 分支会自动触发 Debug 构建。

### 方法二: 手动触发

1. 进入 GitHub 仓库
2. 点击 "Actions" 标签
3. 选择 "Build UUVPN" workflow
4. 点击 "Run workflow"
5. 选择构建选项:
   - `build_android`: 是否构建 Android APK
   - `build_ios`: 是否构建 iOS IPA
   - `release_type`: 构建类型 (alpha/beta/release)
6. 点击 "Run workflow" 按钮

---

## 构建产物

### Android 构建产物

构建完成后,可以在以下位置找到 APK:

1. **Actions Artifacts**: 每个 workflow 运行都会保存 APK artifact
2. **GitHub Releases**: 创建标签后,APK 会自动上传到 Release

**APK 文件命名**:
- Debug: `app-meta-alpha-debug.apk`
- Release: `UUVPN-Android-v1.0.0.apk`

### iOS 构建产物

构建完成后,可以在以下位置找到 IPA:

1. **Actions Artifacts**: 每个 workflow 运行都会保存 IPA artifact
2. **GitHub Releases**: 创建标签后,IPA 会自动上传到 Release
3. **TestFlight**: Beta 和正式版本会自动上传到 TestFlight

**IPA 文件命名**:
- Release: `UUVPN-iOS-v1.0.0.ipa`

---

## 自定义配置

### 修改 Android 构建变体

编辑 `.github/workflows/build.yml` 中的构建命令:

```yaml
- name: Build Android APK
  run: |
    cd Android-kotlin-Code
    # 修改为你需要的构建变体
    ./gradlew app:assembleMeta-BetaRelease --stacktrace
```

### 修改 iOS Scheme

编辑 `.github/workflows/build.yml` 中的 scheme:

```yaml
- name: Build iOS App
  run: |
    cd iOS-SwiftUI-Code
    xcodebuild build \
      -project uuvpn.xcodeproj \
      -scheme SFT \  # 修改为你需要的 scheme
      -sdk iphoneos \
      ...
```

### 添加构建缓存

在 workflow 中添加缓存以加速构建:

```yaml
- name: Cache Gradle packages
  uses: actions/cache@v4
  with:
    path: |
      ~/.gradle/caches
      ~/.gradle/wrapper
    key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', '**/gradle-wrapper.properties') }}
    restore-keys: |
      ${{ runner.os }}-gradle-

- name: Cache Swift packages
  uses: actions/cache@v4
  with:
    path: |
      ~/Library/Caches/org.swift.swiftpm
      .build
    key: ${{ runner.os }}-swift-${{ hashFiles('**/Package.resolved') }}
    restore-keys: |
      ${{ runner.os }}-swift-
```

### 添加自定义构建步骤

在 workflow 中添加自定义步骤:

```yaml
- name: Custom build step
  run: |
    # 你的自定义命令
    echo "Running custom build step"
```

---

## 工作流程说明

### 完整构建流程

```
┌─────────────────┐
│   触发构建      │
└────────┬────────┘
         │
         ├─────────────────────┐
         │                     │
         ▼                     ▼
┌─────────────────┐   ┌─────────────────┐
│  构建 Android   │   │    构建 iOS     │
│      APK        │   │      IPA        │
└────────┬────────┘   └────────┬────────┘
         │                     │
         └──────────┬──────────┘
                    │
                    ▼
         ┌─────────────────────┐
         │  创建 GitHub Release │
         │  (仅标签触发)        │
         └──────────┬──────────┘
                    │
                    ├─────────────────────┐
                    │                     │
                    ▼                     ▼
         ┌─────────────────┐   ┌─────────────────┐
         │  上传 APK 到     │   │  上传 IPA 到     │
         │  GitHub Release  │   │  TestFlight      │
         └─────────────────┘   └─────────────────┘
                    │
                    ▼
         ┌─────────────────────┐
         │   发送通知          │
         └─────────────────────┘
```

### 构建类型说明

| 触发条件 | Android | iOS | 发布 |
|---------|---------|-----|------|
| Push to develop | Debug APK | Debug App | 否 |
| Pull Request | Debug APK | Debug App | 否 |
| Push to main | Release APK | Release IPA | 否 |
| Tag v*-alpha | Release APK | Release IPA | GitHub Release (Pre-release) |
| Tag v*-beta | Release APK | Release IPA | GitHub Release + TestFlight |
| Tag v* | Release APK | Release IPA | GitHub Release + TestFlight |

---

## 常见问题

### Q1: Android 构建失败,提示找不到签名密钥?

**A**: 检查以下内容:
- 确认已配置 `ANDROID_KEYSTORE_BASE64` secret
- 确认 Base64 编码正确
- 确认密钥库密码、别名和密钥密码正确

### Q2: iOS 构建失败,提示签名错误?

**A**: 检查以下内容:
- 确认证书未过期
- 确认 Provisioning Profile 包含正确的 App ID
- 确认 Team ID 正确
- 确认证书和 Provisioning Profile 匹配

### Q3: iOS 构建时间过长?

**A**: iOS 构建通常需要 10-20 分钟,这是正常的。可以:
- 使用缓存加速构建
- 只在需要时构建 iOS 版本
- 使用手动触发选择性构建

### Q4: 如何跳过某个平台的构建?

**A**: 使用手动触发时,取消勾选对应平台的构建选项。

### Q5: 构建产物在哪里下载?

**A**:
1. 进入 Actions 页面
2. 点击具体的 workflow 运行记录
3. 在页面底部 "Artifacts" 区域下载

### Q6: 如何查看构建日志?

**A**:
1. 进入 Actions 页面
2. 点击具体的 workflow 运行记录
3. 点击左侧的 job 名称
4. 展开各个步骤查看详细日志

### Q7: TestFlight 上传失败?

**A**: 检查以下内容:
- 确认 App Store Connect API Key 配置正确
- 确认 API Key 有 App Manager 权限
- 确认 App ID 在 App Store Connect 中已创建
- 确认版本号未重复

### Q8: 如何修改构建触发条件?

**A**: 编辑 `.github/workflows/build.yml` 的 `on` 部分:

```yaml
on:
  push:
    branches:
      - main
      - develop
      - feature/*  # 添加更多分支
    tags:
      - 'v*'
  pull_request:
    branches:
      - main
      - develop
```

---

## 进阶配置

### 添加代码质量检查

在构建前添加代码检查:

```yaml
jobs:
  lint:
    name: Code Quality Check
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Android Lint
        run: |
          cd Android-kotlin-Code
          ./gradlew lint

      - name: Swift Lint
        run: |
          brew install swiftlint
          cd iOS-SwiftUI-Code
          swiftlint
```

### 添加单元测试

```yaml
jobs:
  test:
    name: Run Tests
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Android Tests
        run: |
          cd Android-kotlin-Code
          ./gradlew test

      - name: iOS Tests
        run: |
          cd iOS-SwiftUI-Code
          xcodebuild test \
            -project uuvpn.xcodeproj \
            -scheme SFI \
            -destination 'platform=iOS Simulator,name=iPhone 15'
```

### 添加多版本构建

```yaml
strategy:
  matrix:
    xcode-version: ['14.3', '15.0', '15.2']
    include:
      - xcode-version: '14.3'
        ios-deployment-target: '14.0'
      - xcode-version: '15.0'
        ios-deployment-target: '15.0'
      - xcode-version: '15.2'
        ios-deployment-target: '16.0'
```

---

## 成本估算

### GitHub Actions 免费额度

- **总时长**: 每月 2000 分钟 (免费账户)
- **macOS runner**: 按 10 倍计算
- **Linux runner**: 按 1 倍计算

### 实际消耗估算

| 构建类型 | Android | iOS | 总计 |
|---------|---------|-----|------|
| Debug 构建 | ~5 分钟 | ~100 分钟 | ~105 分钟 |
| Release 构建 | ~10 分钟 | ~150 分钟 | ~160 分钟 |
| 完整流程 | ~15 分钟 | ~200 分钟 | ~215 分钟 |

### 建议

- 免费账户每月可进行约 **9-10 次完整构建**
- 建议只在必要时构建 iOS 版本
- 使用手动触发选择性构建
- 考虑升级 GitHub Pro 获得更多额度

---

## 总结

通过 GitHub Actions CI/CD 配置,你可以:

✅ 无需本地 Mac 设备即可构建 iOS 应用
✅ 自动化构建和发布流程
✅ 支持 Android 和 iOS 双平台
✅ 自动上传到 TestFlight 和 GitHub Releases
✅ 接收构建通知

配置好 Secrets 后,只需推送代码或创建标签,即可自动完成构建和发布!