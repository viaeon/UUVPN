# UUVPN API 端点配置指南

本文档详细说明如何配置 UUVPN 的 API 端点,包括 Android 和 iOS 平台的配置方法。

---

## 目录

- [API 配置概述](#api-配置概述)
- [配置字段说明](#配置字段说明)
- [Android 配置方法](#android-配置方法)
- [iOS 配置方法](#ios-配置方法)
- [测试与验证](#测试与验证)
- [常见问题](#常见问题)

---

## API 配置概述

UUVPN 需要配置一个远程 API 端点,用于获取服务器配置信息。该配置采用 JSON 格式,包含 V2Board 面板的 API 地址、支付链接、客服支持等信息。

### 配置 URL 格式

```
https://your-domain.com/api/config.php
```

### 配置返回格式

```json
{
  "baseURL": "https://api.0008.uk/api/v1/",
  "baseDYURL": "https://api.gooapis.com/api/vpnnodes.php",
  "mainregisterURL": "https://lelian.app/#/register?code=",
  "paymentURL": "https://your-payment-gateway.com/pay",
  "telegramurl": "https://t.me/fastlink",
  "kefuurl": "https://gooapis.com/fastlink/",
  "websiteURL": "https://gooapis.com/fastlink/",
  "crisptoken": "5546c6ea-4b1e-41bc-80e4-4b6648cbca76",
  "banners": [
    "https://image.gooapis.com/api/images/12-11-56.png",
    "https://image.gooapis.com/api/images/12-44-57.png",
    "https://image.gooapis.com/api/images/12-47-03.png"
  ],
  "message": "OK",
  "code": 1
}
```

---

## 配置字段说明

### 1. baseURL

- **类型**: String
- **必填**: 是
- **描述**: V2Board 面板的主要 API 端点
- **示例**: `https://api.0008.uk/api/v1/`
- **用途**: 所有与 V2Board 服务器的 API 请求都将基于此 URL,包括:
  - 用户登录/注册
  - 获取节点列表
  - 获取订阅信息
  - 用户信息管理

### 2. baseDYURL

- **类型**: String
- **必填**: 是
- **描述**: VPN 节点测试端点
- **示例**: `https://api.gooapis.com/api/vpnnodes.php`
- **用途**: 用于测试 VPN 节点的连通性和速度,通常用于应用内的节点测速功能

### 3. mainregisterURL

- **类型**: String
- **必填**: 是
- **描述**: 用户注册页面 URL(带邀请码参数)
- **示例**: `https://lelian.app/#/register?code=`
- **用途**: 引导用户注册,支持邀请码系统
- **注意**: URL 末尾需要保留 `code=` 参数,应用会自动填充邀请码

### 4. paymentURL

- **类型**: String
- **必填**: 是
- **描述**: 支付网关 URL
- **示例**: `https://your-payment-gateway.com/pay`
- **用途**:
  - **正常模式** (URL 长度 > 3): 显示外部支付选项,启用订阅功能
  - **审核模式** (URL 长度 ≤ 3): 隐藏外部支付,遵守 App Store 指南
- **iOS 重要说明**:
  - 正常值: `https://payment.example.com/pay` (显示支付功能)
  - 审核值: `xxx` 或 `xx` (隐藏支付功能,用于 App Store 审核)

### 5. telegramurl

- **类型**: String
- **必填**: 否
- **描述**: Telegram 支持频道/群组链接
- **示例**: `https://t.me/fastlink`
- **用途**: 提供用户 Telegram 客服支持入口

### 6. kefuurl

- **类型**: String
- **必填**: 否
- **描述**: 在线客服页面 URL
- **示例**: `https://gooapis.com/fastlink/`
- **用途**: 提供网页版在线客服入口

### 7. websiteURL

- **类型**: String
- **必填**: 否
- **描述**: 官方网站 URL
- **示例**: `https://gooapis.com/fastlink/`
- **用途**: 应用内关于页面或官网链接

### 8. crisptoken

- **类型**: String
- **必填**: 否
- **描述**: Crisp 聊天服务认证令牌
- **示例**: `5546c6ea-4b1e-41bc-80e4-4b6648cbca76`
- **用途**: 集成 Crisp 实时聊天功能
- **获取方式**: 在 [Crisp 官网](https://crisp.chat/) 注册后获取

### 9. banners

- **类型**: Array of Strings
- **必填**: 否
- **描述**: 首页横幅图片 URL 数组
- **示例**:
  ```json
  [
    "https://image.gooapis.com/api/images/12-11-56.png",
    "https://image.gooapis.com/api/images/12-44-57.png"
  ]
  ```
- **用途**: 应用首页轮播图展示
- **建议尺寸**: 750x300 像素
- **格式支持**: PNG, JPG, WebP

### 10. message

- **类型**: String
- **必填**: 是
- **描述**: API 响应状态消息
- **示例**: `OK`
- **用途**: 标识配置请求是否成功

### 11. code

- **类型**: Integer
- **必填**: 是
- **描述**: API 响应状态码
- **示例**: `1` (成功) 或 `0` (失败)
- **用途**: 应用根据此字段判断配置是否有效

---

## Android 配置方法

### 方法一: 修改配置文件 (推荐)

1. **定位配置文件**

   在 Android 项目中找到以下文件:
   ```
   Android-kotlin-Code/app/src/main/java/com/xxx/xxx/config/ApiConfig.kt
   ```

2. **修改配置 URL**

   找到 `configURL` 或类似的配置常量:
   ```kotlin
   const val CONFIG_URL = "https://your-domain.com/api/config.php"
   ```

3. **重新编译 APK**

   ```bash
   ./gradlew app:assembleMeta-AlphaRelease
   ```

### 方法二: 动态配置

如果支持动态配置,可以在应用启动时请求配置 URL:

```kotlin
// 在 Application 或 MainActivity 中
ConfigManager.init(this, "https://your-domain.com/api/config.php")
```

### Android API 请求示例

```kotlin
// ApiService.kt
interface ApiService {
    @GET
    suspend fun getConfig(@Url url: String): Response<ConfigResponse>
}

data class ConfigResponse(
    val baseURL: String,
    val baseDYURL: String,
    val mainregisterURL: String,
    val paymentURL: String,
    val telegramurl: String,
    val kefuurl: String,
    val websiteURL: String,
    val crisptoken: String,
    val banners: List<String>,
    val message: String,
    val code: Int
)
```

---

## iOS 配置方法

### 方法一: 修改 StoreManager.swift (推荐)

1. **定位配置文件**

   在 iOS 项目中找到:
   ```
   iOS-SwiftUI-Code/ApplicationLibrary/Service/StoreManager.swift
   ```

2. **修改配置 URL**

   找到 `configURL` 常量并修改:
   ```swift
   public let configURL = "https://your-domain.com/api/config.php"
   ```

3. **重新编译应用**

   在 Xcode 中按 `Cmd + B` 编译项目

### 方法二: 使用 Info.plist

1. **在 Info.plist 中添加配置**

   ```xml
   <key>ConfigURL</key>
   <string>https://your-domain.com/api/config.php</string>
   ```

2. **在代码中读取**

   ```swift
   if let configURL = Bundle.main.infoDictionary?["ConfigURL"] as? String {
       // 使用配置 URL
   }
   ```

### iOS 网络请求示例

```swift
// StoreManager.swift
func fetchConfig() async throws -> ConfigResponse {
    guard let url = URL(string: configURL) else {
        throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "bid")
    request.addValue(appVersion, forHTTPHeaderField: "appver")

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(ConfigResponse.self, from: data)
}

// 数据模型
struct ConfigResponse: Codable {
    let baseURL: String
    let baseDYURL: String
    let mainregisterURL: String
    let paymentURL: String
    let telegramurl: String
    let kefuurl: String
    let websiteURL: String
    let crisptoken: String
    let banners: [String]
    let message: String
    let code: Int
}
```

---

## 测试与验证

### 测试配置地址

项目提供了测试配置地址供开发调试使用:

```
https://vungles.com/api/test/config
```

**测试账号**:
- 邮箱: `binance3980@gmail.com`
- 密码: `Tinkl123`

### 验证配置是否正确

1. **浏览器测试**

   在浏览器中访问你的配置 URL,确认返回正确的 JSON 格式

2. **Postman 测试**

   使用 Postman 发送 GET 请求,验证响应内容

3. **应用内测试**

   - 启动应用
   - 检查是否能正常加载首页横幅图
   - 测试登录/注册功能
   - 验证节点列表加载

### 错误排查

如果配置加载失败:

1. **检查 URL 是否正确**
   ```
   https://your-domain.com/api/config.php
   ```

2. **检查 HTTPS 证书**
   - 确保证书有效且未过期
   - 使用可信 CA 签发的证书

3. **检查 JSON 格式**
   - 使用 JSON 格式化工具验证
   - 确保所有必填字段都存在

4. **检查 CORS 配置** (Web 端)
   - 服务器需要配置正确的 CORS 头

---

## 部署配置服务器

### 方案一: 静态 JSON 文件 (推荐)

将配置 JSON 存储在 CDN 或对象存储服务:

1. **创建配置文件**

   创建 `config.json`:
   ```json
   {
     "baseURL": "https://api.yourdomain.com/api/v1/",
     "baseDYURL": "https://api.yourdomain.com/api/vpnnodes.php",
     "mainregisterURL": "https://yourdomain.com/#/register?code=",
     "paymentURL": "https://pay.yourdomain.com/",
     "telegramurl": "https://t.me/yourchannel",
     "kefuurl": "https://yourdomain.com/support/",
     "websiteURL": "https://yourdomain.com/",
     "crisptoken": "your-crisp-token",
     "banners": [
       "https://cdn.yourdomain.com/banner1.png"
     ],
     "message": "OK",
     "code": 1
   }
   ```

2. **上传到对象存储**

   - 阿里云 OSS
   - 腾讯云 COS
   - AWS S3
   - Cloudflare R2

3. **启用 HTTPS**

   确保存储桶启用 HTTPS 访问

### 方案二: 动态 API 接口

使用后端服务动态返回配置:

**PHP 示例**:
```php
<?php
// config.php
header('Content-Type: application/json');

$config = [
    'baseURL' => 'https://api.yourdomain.com/api/v1/',
    'baseDYURL' => 'https://api.yourdomain.com/api/vpnnodes.php',
    'mainregisterURL' => 'https://yourdomain.com/#/register?code=',
    'paymentURL' => 'https://pay.yourdomain.com/',
    'telegramurl' => 'https://t.me/yourchannel',
    'kefuurl' => 'https://yourdomain.com/support/',
    'websiteURL' => 'https://yourdomain.com/',
    'crisptoken' => 'your-crisp-token',
    'banners' => [
        'https://cdn.yourdomain.com/banner1.png',
        'https://cdn.yourdomain.com/banner2.png'
    ],
    'message' => 'OK',
    'code' => 1
];

echo json_encode($config, JSON_PRETTY_PRINT);
?>
```

**Node.js 示例**:
```javascript
// config.js
const express = require('express');
const app = express();

app.get('/api/config', (req, res) => {
    res.json({
        baseURL: 'https://api.yourdomain.com/api/v1/',
        baseDYURL: 'https://api.yourdomain.com/api/vpnnodes.php',
        mainregisterURL: 'https://yourdomain.com/#/register?code=',
        paymentURL: 'https://pay.yourdomain.com/',
        telegramurl: 'https://t.me/yourchannel',
        kefuurl: 'https://yourdomain.com/support/',
        websiteURL: 'https://yourdomain.com/',
        crisptoken: 'your-crisp-token',
        banners: [
            'https://cdn.yourdomain.com/banner1.png'
        ],
        message: 'OK',
        code: 1
    });
});

app.listen(3000, () => {
    console.log('Config server running on port 3000');
});
```

---

## 安全建议

### 1. 使用 HTTPS

- 所有 API 端点必须使用 HTTPS
- 使用可信 CA 签发的 SSL 证书
- 禁用 HTTP 访问

### 2. 请求验证

在请求头中添加验证信息:

```kotlin
// Android
request.addHeader("bid", BuildConfig.APPLICATION_ID)
request.addHeader("appver", BuildConfig.VERSION_NAME)
request.addHeader("device", android.os.Build.MODEL)
```

```swift
// iOS
request.addValue(Bundle.main.bundleIdentifier ?? "", forHTTPHeaderField: "bid")
request.addValue(appVersion, forHTTPHeaderField: "appver")
request.addValue(UIDevice.current.model, forHTTPHeaderField: "device")
```

### 3. 服务器端验证

在服务器端验证请求来源:

```php
<?php
$bid = $_SERVER['HTTP_BID'] ?? '';
$appver = $_SERVER['HTTP_APPVER'] ?? '';

// 验证 Bundle ID
$allowedBids = ['com.yourcompany.uuvpn', 'com.yourcompany.uuvpn.dev'];
if (!in_array($bid, $allowedBids)) {
    http_response_code(403);
    exit(json_encode(['code' => 0, 'message' => 'Unauthorized']));
}

// 返回配置
// ...
?>
```

### 4. 敏感信息保护

- 不要在配置文件中存储密钥或密码
- 使用 token 而非明文密码
- 定期更新 Crisp token

---

## iOS App Store 审核配置

### 审核模式配置

iOS 应用提交 App Store 审核时,需要隐藏外部支付链接:

```json
{
  "baseURL": "https://api.yourdomain.com/api/v1/",
  "baseDYURL": "https://api.yourdomain.com/api/vpnnodes.php",
  "mainregisterURL": "https://yourdomain.com/#/register?code=",
  "paymentURL": "xx",
  "telegramurl": "https://t.me/yourchannel",
  "kefuurl": "https://yourdomain.com/support/",
  "websiteURL": "https://yourdomain.com/",
  "crisptoken": "your-crisp-token",
  "banners": [],
  "message": "OK",
  "code": 1
}
```

**关键点**:
- `paymentURL` 设置为 `"xx"` 或 `"xxx"` (长度 ≤ 3)
- `banners` 设置为空数组,避免显示包含支付信息的横幅

### 审核通过后配置

审核通过后,将配置改回正常模式:

```json
{
  "paymentURL": "https://pay.yourdomain.com/",
  "banners": [
    "https://cdn.yourdomain.com/banner1.png"
  ]
}
```

---

## 常见问题

### Q1: 修改配置后应用没有更新怎么办?

**A**: 清除应用缓存或重新安装应用

**Android**:
```bash
adb shell pm clear com.yourcompany.uuvpn
```

**iOS**: 卸载重装应用

### Q2: 配置请求超时怎么办?

**A**: 检查以下内容:
- 服务器是否正常运行
- HTTPS 证书是否有效
- 网络连接是否正常
- 考虑使用 CDN 加速

### Q3: 如何在不重新编译的情况下更改配置?

**A**: 配置是从远程 URL 动态获取的,只需修改服务器端的配置 JSON 即可,应用会在下次启动时自动获取最新配置

### Q4: 能否使用多个配置 URL?

**A**: 可以,通过在不同的编译变体中使用不同的配置 URL:

**Android**:
```kotlin
object ApiConfig {
    val CONFIG_URL = when (BuildConfig.BUILD_TYPE) {
        "debug" -> "https://dev.yourdomain.com/api/config.php"
        "release" -> "https://yourdomain.com/api/config.php"
        else -> "https://yourdomain.com/api/config.php"
    }
}
```

**iOS**:
```swift
#if DEBUG
let configURL = "https://dev.yourdomain.com/api/config.php"
#else
let configURL = "https://yourdomain.com/api/config.php"
#endif
```

### Q5: 配置加载失败应用会崩溃吗?

**A**: 不会,应用应该有默认配置作为后备:

```kotlin
// Android
fun getConfig(): ConfigResponse {
    return try {
        apiService.getConfig(configURL)
    } catch (e: Exception) {
        // 返回默认配置
        getDefaultConfig()
    }
}
```

```swift
// iOS
func loadConfig() async {
    do {
        config = try await fetchConfig()
    } catch {
        // 使用默认配置
        config = getDefaultConfig()
    }
}
```

---

## 总结

配置 API 端点是 UUVPN 应用的核心步骤,正确的配置能确保应用正常工作:

1. ✅ 准备好 V2Board 服务器
2. ✅ 创建配置 JSON 文件
3. ✅ 部署到 HTTPS 服务器
4. ✅ 在应用中配置 URL
5. ✅ 测试验证配置
6. ✅ 针对iOS审核特殊处理

如有问题,请参考 [GitHub Issues](https://github.com/nicolastinkl/UUVPN/issues) 或联系技术支持。
