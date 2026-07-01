# GitHub Actions CI/CD 快速入门指南

本指南帮助你快速配置和使用 UUVPN 的自动构建系统。

---

## 🚀 5 分钟快速开始

### 第一步: 准备工作

确保你已拥有:

- ✅ GitHub 账号
- ✅ UUVPN 代码仓库的写权限
- ✅ Apple Developer 账号 (iOS 构建必需)
- ✅ Android 签名密钥库 (Android Release 构建必需)

### 第二步: 安装 GitHub CLI

**Windows**:
```powershell
winget install GitHub.cli
```

**macOS**:
```bash
brew install gh
```

**Linux**:
```bash
# Debian/Ubuntu
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

### 第三步: 登录 GitHub

```bash
gh auth login
```

按照提示选择:
- GitHub.com
- HTTPS
- 使用浏览器登录或粘贴 token

### 第四步: 配置 Secrets

#### 方法一: 使用自动配置脚本 (推荐)

**Windows**:
```powershell
cd D:\Code\UUVPN\.github\workflows
.\setup-secrets.ps1
```

**macOS/Linux**:
```bash
cd /path/to/UUVPN/.github/workflows
chmod +x setup-secrets.sh
./setup-secrets.sh
```

#### 方法二: 手动配置

在 GitHub 仓库页面:

1. 进入 `Settings` → `Secrets and variables` → `Actions`
2. 点击 `New repository secret`
3. 添加所需的 secrets (详见下方)

### 第五步: 触发构建

```bash
# 推送代码触发构建
git push origin main

# 或创建标签触发发布
git tag v1.0.0-alpha
git push origin v1.0.0-alpha
```

---

## 📋 必需的 Secrets 清单

### Android 构建

| Secret | 必需 | 说明 |
|--------|------|------|
| `ANDROID_KEYSTORE_BASE64` | ✅ | 签名密钥库的 Base64 编码 |
| `ANDROID_KEYSTORE_PASSWORD` | ✅ | 密钥库密码 |
| `ANDROID_KEY_ALIAS` | ✅ | 密钥别名 |
| `ANDROID_KEY_PASSWORD` | ✅ | 密钥密码 |

### iOS 构建

| Secret | 必需 | 说明 |
|--------|------|------|
| `IOS_CERTIFICATES_P12` | ✅ | 开发者证书 Base64 编码 |
| `IOS_CERTIFICATES_PASSWORD` | ✅ | 证书密码 |
| `IOS_TEAM_ID` | ✅ | Apple Team ID |
| `IOS_SIGNING_IDENTITY` | ✅ | 签名身份 |
| `IOS_PROVISIONING_PROFILE` | ✅ | Provisioning Profile Base64 |

### TestFlight 上传 (可选)

| Secret | 必需 | 说明 |
|--------|------|------|
| `APP_STORE_CONNECT_ISSUER_ID` | ⭐ | App Store Connect Issuer ID |
| `APP_STORE_CONNECT_API_KEY_ID` | ⭐ | API Key ID |
| `APP_STORE_CONNECT_API_PRIVATE_KEY` | ⭐ | API 私钥 |

### 通知 (可选)

| Secret | 必需 | 说明 |
|--------|------|------|
| `TELEGRAM_BOT_TOKEN` |  | Telegram Bot Token |
| `TELEGRAM_CHAT_ID` |  | Telegram Chat ID |

---

## 🔧 详细配置步骤

### Android 签名密钥库

#### 1. 创建密钥库 (如果没有)

```bash
keytool -genkey -v \
  -keystore release.keystore \
  -alias uuvpn \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000
```

按提示输入:
- 密钥库密码
- 个人信息
- 密钥密码

#### 2. 转换为 Base64

**macOS/Linux**:
```bash
base64 -i release.keystore -o release.keystore.base64
```

**Windows PowerShell**:
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("release.keystore")) | Out-File release.keystore.base64
```

#### 3. 添加到 GitHub Secrets

复制 `release.keystore.base64` 文件内容,添加为 `ANDROID_KEYSTORE_BASE64` secret。

### iOS 开发者证书

#### 1. 导出证书

1. 打开 "钥匙串访问" (Keychain Access)
2. 找到 "Apple Distribution" 证书
3. 右键 → 导出
4. 选择 .p12 格式
5. 设置密码

#### 2. 转换为 Base64

**macOS**:
```bash
base64 -i certificate.p12 -o certificate.p12.base64
```

#### 3. 下载 Provisioning Profile

1. 登录 [Apple Developer](https://developer.apple.com/)
2. 进入 Certificates, Identifiers & Profiles
3. 下载对应的 Provisioning Profile

#### 4. 转换为 Base64

```bash
base64 -i uuvpn.mobileprovision -o uuvpn.mobileprovision.base64
```

### App Store Connect API Key

#### 1. 创建 API Key

1. 登录 [App Store Connect](https://appstoreconnect.apple.com/)
2. 进入 Users and Access → Keys
3. 点击 "Generate API Key"
4. 选择 "App Manager" 权限
5. 下载 .p8 文件

#### 2. 记录信息

- **Issuer ID**: 在 Keys 页面顶部
- **Key ID**: 创建后显示
- **Private Key**: 下载的 .p8 文件内容

---

## 🎯 构建类型说明

### Debug 构建

**触发条件**:
- Pull Request
- 推送到 develop 分支

**特点**:
- 无需签名配置
- 快速构建
- 不发布到 Release

### Release 构建

**触发条件**:
- 推送到 main 分支
- 创建版本标签

**特点**:
- 需要签名配置
- 自动发布到 GitHub Releases
- 可选上传到 TestFlight

### 版本标签格式

```bash
# Alpha 版本 (预发布)
git tag v1.0.0-alpha
git push origin v1.0.0-alpha

# Beta 版本 (预发布,上传 TestFlight)
git tag v1.0.0-beta
git push origin v1.0.0-beta

# 正式版本 (发布,上传 TestFlight)
git tag v1.0.0
git push origin v1.0.0
```

---

## 📥 下载构建产物

### 方法一: Actions Artifacts

1. 进入 GitHub 仓库
2. 点击 "Actions" 标签
3. 选择具体的 workflow 运行记录
4. 在页面底部 "Artifacts" 区域下载

### 方法二: GitHub Releases

1. 进入 GitHub 仓库
2. 点击 "Releases" 标签
3. 找到对应版本
4. 下载 APK 或 IPA 文件

---

## 🛠️ 故障排查

### 构建失败

1. **查看日志**:
   - 进入 Actions 页面
   - 点击失败的步骤
   - 查看详细错误信息

2. **常见错误**:
   - ❌ 签名错误: 检查 Secrets 配置
   - ❌ 证书过期: 更新证书和 Profile
   - ❌ 构建超时: 优化构建配置

### iOS 签名失败

检查清单:
- [ ] 证书未过期
- [ ] Provisioning Profile 包含正确 App ID
- [ ] Team ID 正确
- [ ] 证书和 Profile 匹配

### TestFlight 上传失败

检查清单:
- [ ] API Key 有 App Manager 权限
- [ ] App ID 在 App Store Connect 已创建
- [ ] 版本号未重复

---

## 💡 最佳实践

### 1. 分支策略

```
main (稳定版本)
  ↑
develop (开发版本)
  ↑
feature/* (功能分支)
```

### 2. 版本号规范

使用语义化版本:
- `v1.0.0-alpha`: 内部测试版本
- `v1.0.0-beta`: 公开测试版本
- `v1.0.0`: 正式发布版本

### 3. 节省构建时间

- 只在需要时构建 iOS (macOS runner 费用高)
- 使用缓存加速构建
- 手动触发选择性构建

### 4. 安全建议

- 定期更新签名密钥
- 使用最小权限原则
- 不要在代码中硬编码敏感信息

---

## 📞 获取帮助

### 文档

- [GitHub Actions 文档](https://docs.github.com/en/actions)
- [详细配置说明](./README.md)
- [API 配置指南](../../API配置指南.md)

### 支持

- 查看仓库 [Issues](https://github.com/nicolastinkl/UUVPN/issues)
- Telegram: @fastlink

---

## ✅ 配置验证清单

完成配置后,检查以下内容:

- [ ] 已安装 GitHub CLI
- [ ] 已登录 GitHub CLI
- [ ] 已配置 Android Secrets (如需 Android 构建)
- [ ] 已配置 iOS Secrets (如需 iOS 构建)
- [ ] 已配置 App Store Connect API (如需 TestFlight)
- [ ] 已推送代码触发构建
- [ ] 构建成功
- [ ] 可以下载构建产物

---

**祝你构建顺利! 🎉**