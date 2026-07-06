# X连接 API 字段类型说明

## 问题背景

在对接 Xboard 后端 API 时，发现部分字段在不同接口返回的类型不一致，需要在客户端代码中做兼容处理。

---

## 字段类型不一致问题

### `sell` 字段

| 接口 | 返回类型 | 示例值 |
|------|---------|--------|
| `/api/v1/user/getSubscribe` | `Int` | `"sell": 1` |
| `/api/v1/user/plan/fetch` | `Boolean` | `"sell": true` |

**解决方案：**

在 `PlanData` 数据类中：
- 字段类型定义为 `Any?`
- 添加辅助属性 `isSell` 进行类型转换

```kotlin
@SerializedName("sell") val sell : Any?

// 辅助属性：将 sell 转换为布尔值（兼容整数和布尔类型）
val isSell: Boolean
    get() = when (sell) {
        is Boolean -> sell as Boolean
        is Number -> (sell as Number).toInt() != 0
        null -> false
        else -> false
    }
```

---

## 其他注意事项

### `PlanData` 字段

为确保 JSON 解析稳定性，以下字段定义为可空类型：

| 字段 | 类型 | 说明 |
|------|------|------|
| `id` | `Int?` | 套餐ID |
| `name` | `String?` | 套餐名称 |
| `show` | `Boolean?` | 是否显示 |
| `renew` | `Boolean?` | 是否可续费 |
| `sell` | `Any?` | 是否可购买（类型不一致） |

### `SubscribeData` 字段

| 字段 | 类型 | 说明 |
|------|------|------|
| `device_limit` | `Int?` | 设备限制数 |
| `speed_limit` | `Int?` | 速度限制 |
| `next_reset_at` | `Long?` | 下次重置时间 |

---

## 相关文件

- [ApiService.kt](Android-kotlin-Code/design/src/main/java/com/github/kr328/clash/design/network/ApiService.kt) - API 接口和数据类定义
- [ApiClient.kt](Android-kotlin-Code/design/src/main/java/com/github/kr328/clash/design/network/ApiClient.kt) - Retrofit 客户端配置

---

## 更新日志

- 2026-07-03: 发现并修复 `sell` 字段类型不一致问题
- 2026-07-03: 添加 `SubscribeData` 缺失字段
- 2026-07-03: 修复 Retrofit baseUrl 必须以 `/` 结尾的问题
