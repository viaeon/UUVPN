//
//  FlexibleDecoding.swift
//  SFI
//
//  处理 V2Board/Xboard API 字段类型不一致问题的解码辅助
//  例如: sell 字段在不同接口返回 Int 或 Bool
//

import Foundation

/// 从 decoder 中解码一个可能是 Int 或 Bool 的值为 Int
/// - Bool true → 1, Bool false → 0
/// - Int → 原值
/// - Double/Float → Int 截断
/// - 其他 → defaultValue
func decodeIntOrBool<K: CodingKey>(from container: KeyedDecodingContainer<K>, key: K, defaultValue: Int = 0) -> Int {
    if let intValue = try? container.decodeIfPresent(Int.self, forKey: key) {
        return intValue
    }
    if let boolValue = try? container.decodeIfPresent(Bool.self, forKey: key) {
        return boolValue ? 1 : 0
    }
    if let doubleValue = try? container.decodeIfPresent(Double.self, forKey: key) {
        return Int(doubleValue)
    }
    return defaultValue
}

/// 从 decoder 中解码一个可能是 Int 或 Bool 的值为可选 Int
func decodeIntOrBoolOptional<K: CodingKey>(from container: KeyedDecodingContainer<K>, key: K) -> Int? {
    if let intValue = try? container.decodeIfPresent(Int.self, forKey: key) {
        return intValue
    }
    if let boolValue = try? container.decodeIfPresent(Bool.self, forKey: key) {
        return boolValue ? 1 : 0
    }
    if let doubleValue = try? container.decodeIfPresent(Double.self, forKey: key) {
        return Int(doubleValue)
    }
    return nil
}

/// 解码可能是 String 或 Number 的值为 String
func decodeStringOrNumber<K: CodingKey>(from container: KeyedDecodingContainer<K>, key: K, defaultValue: String = "") -> String {
    if let stringValue = try? container.decodeIfPresent(String.self, forKey: key) {
        return stringValue
    }
    if let intValue = try? container.decodeIfPresent(Int.self, forKey: key) {
        return String(intValue)
    }
    if let doubleValue = try? container.decodeIfPresent(Double.self, forKey: key) {
        return String(doubleValue)
    }
    return defaultValue
}
