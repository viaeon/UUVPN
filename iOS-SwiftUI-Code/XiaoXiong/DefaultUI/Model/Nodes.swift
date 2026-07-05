//
//  Nodes.swift
//  SFI
//
//  Created by Mac on 2024/10/13.
//

import Foundation
// MARK: - Welcome
struct nodereponse: Codable {
    let data: [nodereponseData]?
    let message: String?
}

// MARK: - Datum
struct nodereponseData: Codable,Identifiable {
//    let id: Int
    var id = UUID().uuidString

    let type, name: String?
    let rate: String
    let id2: Int?
    let isOnline: Int
    let cacheKey: String?

    enum CodingKeys: String, CodingKey {
        case type, name, rate
        case isOnline = "is_online"
        case id2 = "id"
        case cacheKey = "cache_key"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decodeIfPresent(String.self, forKey: .type)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        // rate 可能是 String 或 Number
        rate = decodeStringOrNumber(from: container, key: .rate)
        id2 = try container.decodeIfPresent(Int.self, forKey: .id2)
        // isOnline 可能是 Int 或 Bool
        isOnline = decodeIntOrBool(from: container, key: .isOnline)
        cacheKey = try container.decodeIfPresent(String.self, forKey: .cacheKey)
    }
}
