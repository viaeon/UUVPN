# GitHub Secrets 详细说明和获取方法

本文档详细说明 UUVPN CI/CD 所需的每个 Secret 的含义和获取方法。

---

## 📋 Secrets 清单总览

| Secret 名称 | 平台 | 必需程度 | 说明 |
|------------|------|---------|------|
| ANDROID_KEYSTORE_BASE64 | Android | Release 必需 | 签名密钥库的 Base64 编码 |
| ANDROID_KEYSTORE_PASSWORD | Android | Release 必需 | 密钥库密码 |
| ANDROID_KEY_ALIAS | Android | Release 必需 | 密钥别名 |
| ANDROID_KEY_PASSWORD | Android | Release 必需 | 密钥密码 |
| IOS_CERTIFICATES_P12 | iOS | Release 必需 | 开发者证书的 Base64 编码 |
| IOS_CERTIFICATES_PASSWORD | iOS | Release 必需 | 证书密码 |
| IOS_TEAM_ID | iOS | Release 必需 | Apple Team ID |
| IOS_SIGNING_IDENTITY | iOS | Release 必需 | 签名身份 |
| IOS_PROVISIONING_PROFILE | iOS | Release 必需 | Provisioning Profile 的 Base64 编码 |
| APP_STORE_CONNECT_ISSUER_ID | iOS | 可选 | App Store Connect API Issuer ID |
| APP_STORE_CONNECT_API_KEY_ID | iOS | 可选 | App Store Connect API Key ID |
| APP_STORE_CONNECT_API_PRIVATE_KEY | iOS | 可选 | App Store Connect API 私钥 |
| TELEGRAM_BOT_TOKEN | 通知 | 可选 | Telegram Bot Token |
| TELEGRAM_CHAT_ID | 通知 | 可选 | Telegram Chat ID |

---

## 🤖 Android Secrets

### 1. ANDROID_KEYSTORE_BASE64

**含义**: Android 应用签名密钥库文件的 Base64 编码字符串

**为什么需要**: Android 要求所有 APK 在发布前必须签名。Release 版本需要使用你自己的签名密钥,而不是 Debug 密钥。

**获取方法**:

#### 步骤 1: 生成签名密钥库

如果你还没有签名密钥库,需要先创建:

**Windows (PowerShell)**:
```powershell
keytool -genkey -v -keystore release.keystore -alias uuvpn -keyalg RSA -keysize 2048 -validity 10000
```

**macOS/Linux**:
```bash
keytool -genkey -v -keystore release.keystore -alias uuvpn -keyalg RSA -keysize 2048 -validity 10000
```

按提示输入:
- 密钥库密码 (记住这个密码,后面要用)
- 个人信息 (姓名、组织、城市等)
- 密钥密码 (可以直接回车使用与密钥库相同的密码)

**重要**: 请妥善保管 `release.keystore` 文件,丢失后无法恢复,已发布的应用将无法更新!

#### 步骤 2: 转换为 Base64

**Windows (PowerShell)**:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("release.keystore")) | Out-File release.keystore.base64 -Encoding UTF8
```

**macOS/Linux**:
```bash
base64 -i release.keystore -o release.keystore.base64
```

#### 步骤 3: 添加到 GitHub

1. 打开生成的 `release.keystore.base64` 文件
2. 复制全部内容
3. 在 GitHub 仓库中添加 Secret,名称为 `ANDROID_KEYSTORE_BASE64`,值为复制的内容

---

### 2. ANDROID_KEYSTORE_PASSWORD

**含义**: 签名密钥库的密码

**获取方法**: 这就是你在步骤 1 生成密钥库时设置的密码

**添加到 GitHub**: 直接输入密码字符串

---

### 3. ANDROID_KEY_ALIAS

**含义**: 密钥库中的密钥别名

**获取方法**: 这是你在生成密钥库时指定的别名,在上面的例子中是 `uuvpn`

如果你忘记了别名,可以查看密钥库内容:

**Windows (PowerShell)**:
```powershell
keytool -list -keystore release.keystore
```

**macOS/Linux**:
```bash
keytool -list -keystore release.keystore
```

输入密钥库密码后,会显示类似:
```
Keystore type: PKCS12
Keystore provider: SUN

Your keystore contains 1 entry

uuvpn, 2026-07-01, PrivateKeyEntry,
Certificate fingerprint (SHA-256): ...
```

这里的 `uuvpn` 就是别名。

**添加到 GitHub**: 输入别名,例如 `uuvpn`

---

### 4. ANDROID_KEY_PASSWORD

**含义**: 密钥的密码

**获取方法**: 这是你在生成密钥库时设置的密钥密码。如果你在生成时直接按回车,那么它和密钥库密码相同。

**添加到 GitHub**: 输入密码字符串

---

## 🍎 iOS Secrets

### 1. IOS_CERTIFICATES_P12

**含义**: Apple 开发者证书的 Base64 编码

**为什么需要**: iOS 应用在真机运行或发布到 App Store 时,必须有有效的签名证书。

**前置要求**:
- Apple Developer 账号 ($99/年)
- 已创建 App ID
- 已创建开发/发布证书

**获取方法**:

#### 步骤 1: 在 Apple Developer 网站创建证书

1. 登录 [Apple Developer](https://developer.apple.com/account/)
2. 进入 "Certificates, Identifiers & Profiles"
3. 点击 "Certificates" → "+" 创建新证书
4. 选择 "Apple Distribution" (用于发布到 App Store)
5. 按提示上传 CSR 文件 (Certificate Signing Request)
   - 在 Mac 上打开 "钥匙串访问" → "证书助理" → "从证书颁发机构请求证书"
   - 填写信息,选择 "保存到磁盘"
   - 上传生成的 CSR 文件
6. 下载证书 (.cer 文件)

#### 步骤 2: 导出为 .p12 文件

**在 Mac 上**:
1. 双击下载的 .cer 文件,将其添加到钥匙串
2. 打开 "钥匙串访问" 应用
3. 在 "我的证书" 分类中找到刚添加的证书
   - 名称类似: "Apple Distribution: Your Name (TEAM_ID)"
4. 右键点击证书 → "导出..."
5. 选择保存位置,格式选择 "个人信息交换 (.p12)"
6. 设置密码 (记住这个密码,后面要用)

**在 Windows 上**:
如果你没有 Mac,可以:
1. 使用虚拟机安装 macOS
2. 使用云端 Mac 服务
3. 找有 Mac 的朋友帮忙

#### 步骤 3: 转换为 Base64

**macOS/Linux**:
```bash
base64 -i certificate.p12 -o certificate.p12.base64
```

**Windows (PowerShell)**:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("certificate.p12")) | Out-File certificate.p12.base64 -Encoding UTF8
```

#### 步骤 4: 添加到 GitHub

1. 打开生成的 `certificate.p12.base64` 文件
2. 复制全部内容
3. 在 GitHub 仓库中添加 Secret,名称为 `IOS_CERTIFICATES_P12`

---

### 2. IOS_CERTIFICATES_PASSWORD

**含义**: 导出 .p12 证书时设置的密码

**获取方法**: 这就是你在步骤 2 导出证书时设置的密码

**添加到 GitHub**: 直接输入密码字符串

---

### 3. IOS_TEAM_ID

**含义**: Apple Developer Team ID,用于标识你的开发者账号

**获取方法**:

1. 登录 [Apple Developer](https://developer.apple.com/account/)
2. 点击右上角的账户信息
3. 在 "Membership" 页面可以看到 "Team ID"
   - 格式: 10 个字符,例如: `A1B2C3D4E5`

**添加到 GitHub**: 输入 Team ID,例如 `A1B2C3D4E5`

---

### 4. IOS_SIGNING_IDENTITY

**含义**: 签名身份,即证书在钥匙串中显示的完整名称

**获取方法**:

**方法一: 从钥匙串查看**:
1. 打开 "钥匙串访问" 应用
2. 找到你的 Apple Distribution 证书
3. 右键点击 → "显示简介"
4. 查看完整名称,类似:
   - `Apple Distribution: Your Name (A1B2C3D4E5)`
   - 或 `iPhone Distribution: Your Name (A1B2C3D4E5)`

**方法二: 使用命令行**:
```bash
security find-identity -v -p codesigning
```

输出类似:
```
1) ABC123DEF456 "Apple Distribution: Your Name (A1B2C3D4E5)"
```

引号中的内容就是 Signing Identity。

**添加到 GitHub**: 输入完整名称,例如:
```
Apple Distribution: Your Name (A1B2C3D4E5)
```

---

### 5. IOS_PROVISIONING_PROFILE

**含义**: Provisioning Profile 的 Base64 编码,用于授权应用在特定设备上运行

**为什么需要**: Provisioning Profile 包含了应用 ID、开发者证书和设备 UDID 的绑定关系。

**获取方法**:

#### 步骤 1: 创建 Provisioning Profile

1. 登录 [Apple Developer](https://developer.apple.com/account/)
2. 进入 "Certificates, Identifiers & Profiles"
3. 点击 "Profiles" → "+" 创建新的 Profile
4. 选择类型:
   - "App Store" 用于发布到 App Store
   - "Ad Hoc" 用于内部测试
5. 选择 App ID (你的应用 Bundle ID)
6. 选择证书
7. 选择设备 (Ad Hoc 需要,App Store 不需要)
8. 命名并下载 Profile (.mobileprovision 文件)

#### 步骤 2: 转换为 Base64

**macOS/Linux**:
```bash
base64 -i UUVPN.mobileprovision -o profile.base64
```

**Windows (PowerShell)**:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("UUVPN.mobileprovision")) | Out-File profile.base64 -Encoding UTF8
```

#### 步骤 3: 添加到 GitHub

1. 打开生成的 `profile.base64` 文件
2. 复制全部内容
3. 在 GitHub 仓库中添加 Secret,名称为 `IOS_PROVISIONING_PROFILE`

---

## 🚀 App Store Connect Secrets (可选)

这些 Secrets 用于自动上传 IPA 到 TestFlight。

### 1. APP_STORE_CONNECT_ISSUER_ID

**含义**: App Store Connect API 的 Issuer ID

**获取方法**:

1. 登录 [App Store Connect](https://appstoreconnect.apple.com/)
2. 点击右上角用户名 → "Access"
3. 选择 "Keys" 标签
4. 在页面顶部可以看到 "Issuer ID"
   - 格式类似: `12345678-1234-1234-1234-123456789012`

**添加到 GitHub**: 输入 Issuer ID

---

### 2. APP_STORE_CONNECT_API_KEY_ID

**含义**: App Store Connect API Key ID

**获取方法**:

1. 在 App Store Connect 的 "Keys" 页面
2. 点击 "+" 创建新的 API Key
3. 输入名称,选择权限:
   - "App Manager" 权限足够用于上传构建版本
4. 创建后会显示 Key ID
   - 格式类似: `AB12CD34EF`

**添加到 GitHub**: 输入 Key ID

---

### 3. APP_STORE_CONNECT_API_PRIVATE_KEY

**含义**: App Store Connect API 的私钥内容

**获取方法**:

1. 创建 API Key 后,会提供下载 .p8 文件的机会
2. **注意**: 私钥只能下载一次,请妥善保管!
3. 下载后打开 .p8 文件,内容格式如下:
```
-----BEGIN PRIVATE KEY-----
MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQg...
(多行 Base64 编码内容)
-----END PRIVATE KEY-----
```

**添加到 GitHub**: 复制 .p8 文件的全部内容,包括开始和结束标记

---

## 📢 Telegram Secrets (可选)

这些 Secrets 用于发送构建通知到 Telegram。

### 1. TELEGRAM_BOT_TOKEN

**含义**: Telegram Bot 的访问令牌

**获取方法**:

1. 在 Telegram 中搜索 `@BotFather`
2. 发送 `/newbot` 命令
3. 按提示输入 Bot 名称和用户名
4. 创建成功后,会收到 Bot Token
   - 格式类似: `1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`

**添加到 GitHub**: 输入 Bot Token

---

### 2. TELEGRAM_CHAT_ID

**含义**: 接收通知的 Telegram 群组或频道 ID

**获取方法**:

#### 步骤 1: 创建群组或频道

1. 在 Telegram 中创建群组或频道
2. 邀请你的 Bot 加入群组/频道
3. 给 Bot 发送管理员权限

#### 步骤 2: 获取 Chat ID

**方法一: 使用 API**:
1. 在群组中发送一条消息
2. 在浏览器访问:
   ```
   https://api.telegram.org/bot<你的BOT_TOKEN>/getUpdates
   ```
3. 在返回的 JSON 中找到 `"chat":{"id": -123456789}`
4. 这个 ID 就是 Chat ID

**方法二: 使用 @userinfobot**:
1. 在 Telegram 中搜索 `@userinfobot`
2. 将其加入群组
3. 它会自动发送群组信息,包含 Chat ID

**添加到 GitHub**: 输入 Chat ID (注意负号,例如 `-123456789`)

---

## 📝 快速配置清单

### Debug 构建 (测试用)

**Android Debug 构建**: ✅ 无需配置任何 Secrets

**iOS Debug 构建**: ✅ 无需配置任何 Secrets

### Release 构建 (发布用)

**Android Release**:
- [ ] ANDROID_KEYSTORE_BASE64
- [ ] ANDROID_KEYSTORE_PASSWORD
- [ ] ANDROID_KEY_ALIAS
- [ ] ANDROID_KEY_PASSWORD

**iOS Release**:
- [ ] IOS_CERTIFICATES_P12
- [ ] IOS_CERTIFICATES_PASSWORD
- [ ] IOS_TEAM_ID
- [ ] IOS_SIGNING_IDENTITY
- [ ] IOS_PROVISIONING_PROFILE

**TestFlight 自动上传 (可选)**:
- [ ] APP_STORE_CONNECT_ISSUER_ID
- [ ] APP_STORE_CONNECT_API_KEY_ID
- [ ] APP_STORE_CONNECT_API_PRIVATE_KEY

**通知 (可选)**:
- [ ] TELEGRAM_BOT_TOKEN
- [ ] TELEGRAM_CHAT_ID

---

## 🔐 安全建议

1. **定期更新密钥**:
   - 建议每年更新一次签名密钥和证书
   - API Key 如果泄露,立即撤销并重新生成

2. **限制权限**:
   - App Store Connect API Key 使用 "App Manager" 权限即可,不要使用更高权限

3. **妥善保管**:
   - 签名密钥库 (.keystore) 要备份到安全的地方
   - 私钥文件 (.p8) 丢失后无法恢复

4. **不要泄露**:
   - 不要在代码中硬编码任何密钥
   - 不要将密钥文件提交到公开仓库

5. **使用 GitHub Environments**:
   - 可以为不同的环境 (开发/测试/生产) 配置不同的 Secrets
   - 可以设置需要审批才能使用生产环境的 Secrets

---

## ❓ 常见问题

### Q1: 我没有 Apple Developer 账号,可以构建 iOS 应用吗?

**A**: 可以构建 Debug 版本(模拟器运行),但无法:
- 在真机上运行
- 发布到 App Store
- 上传到 TestFlight

### Q2: Android 签名密钥丢失了怎么办?

**A**: 无法恢复!必须:
1. 生成新的签名密钥
2. 更新应用包名 (否则无法更新已发布的应用)
3. 重新发布应用

所以请务必备份密钥库文件!

### Q3: iOS 证书过期了怎么办?

**A**: 需要重新:
1. 创建新的证书
2. 创建新的 Provisioning Profile
3. 更新 GitHub Secrets

### Q4: 可以使用同一个签名密钥发布多个应用吗?

**A**: 可以,但建议:
- 每个应用使用不同的签名密钥
- 提高安全性
- 避免一个密钥泄露影响所有应用

### Q5: Provisioning Profile 需要包含哪些设备?

**A**:
- **App Store Profile**: 不需要包含设备,任何设备都可以从 App Store 下载
- **Ad Hoc Profile**: 需要包含用于测试的设备 UDID

---

## 📚 相关文档

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)
- [GitHub Actions Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
- [App Store Connect API](https://developer.apple.com/documentation/appstoreconnectapi)

---

**配置完成后,就可以享受自动化的 CI/CD 流程了! 🎉**