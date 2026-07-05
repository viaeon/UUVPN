//
//  File.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation

// MARK: - Welcome
struct SubscribeReponse: Codable {
    let data: SubscribeReponseClass?
    let message: String?
    let status: String?
    let error: String?
}

// MARK: - DataClass
struct SubscribeReponseClass: Codable {
    let planID: Int?
    let token: String?
    let expiredAt: Int?

    let u, d, transferEnable: Int?

    let email, uuid: String?
    let deviceLimit: Int?
    let speedLimit: Int?
    let nextResetAt: Int?
    let plan: Plan?
    let subscribeURL: String?
    let resetDay: String?

    enum CodingKeys: String, CodingKey {
        case planID = "plan_id"
        case token
        case expiredAt = "expired_at"
        case u, d
        case transferEnable = "transfer_enable"
        case email, uuid
        case deviceLimit = "device_limit"
        case speedLimit = "speed_limit"
        case nextResetAt = "next_reset_at"
        case plan
        case subscribeURL = "subscribe_url"
        case resetDay = "reset_day"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        planID = try container.decodeIfPresent(Int.self, forKey: .planID)
        token = try container.decodeIfPresent(String.self, forKey: .token)
        expiredAt = try container.decodeIfPresent(Int.self, forKey: .expiredAt)
        u = try container.decodeIfPresent(Int.self, forKey: .u)
        d = try container.decodeIfPresent(Int.self, forKey: .d)
        transferEnable = try container.decodeIfPresent(Int.self, forKey: .transferEnable)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        deviceLimit = try container.decodeIfPresent(Int.self, forKey: .deviceLimit)
        speedLimit = try container.decodeIfPresent(Int.self, forKey: .speedLimit)
        nextResetAt = try container.decodeIfPresent(Int.self, forKey: .nextResetAt)
        plan = try container.decodeIfPresent(Plan.self, forKey: .plan)
        subscribeURL = try container.decodeIfPresent(String.self, forKey: .subscribeURL)
        resetDay = try container.decodeIfPresent(String.self, forKey: .resetDay)
    }
}

// MARK: - Plan
struct Plan: Codable {
    let id: Int?
    let groupID: Int?
    let transferEnable: Int?
    let name: String?
    let speedLimit: Int?
    let deviceLimit: Int?
    let show: Int
    let sort: Int?
    let renew: Int
    let content: String?
    let monthPrice, quarterPrice, halfYearPrice, yearPrice: Int?
    let twoYearPrice, threeYearPrice: Int?
    let onetimePrice: Int?
    let resetPrice: Int?
    let resetTrafficMethod: String?
    let capacityLimit: Int?
    let createdAt, updatedAt: Int?

    /// sell 字段：API 可能返回 Int 或 Bool，用 isSell 访问布尔值
    private let _sellRaw: Int?
    var isSell: Bool { _sellRaw != 0 }

    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case transferEnable = "transfer_enable"
        case name
        case speedLimit = "speed_limit"
        case deviceLimit = "device_limit"
        case show, sort, renew, content
        case monthPrice = "month_price"
        case quarterPrice = "quarter_price"
        case halfYearPrice = "half_year_price"
        case yearPrice = "year_price"
        case twoYearPrice = "two_year_price"
        case threeYearPrice = "three_year_price"
        case onetimePrice = "onetime_price"
        case resetPrice = "reset_price"
        case resetTrafficMethod = "reset_traffic_method"
        case capacityLimit = "capacity_limit"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case _sellRaw = "sell"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        groupID = try container.decodeIfPresent(Int.self, forKey: .groupID)
        transferEnable = try container.decodeIfPresent(Int.self, forKey: .transferEnable)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        speedLimit = try container.decodeIfPresent(Int.self, forKey: .speedLimit)
        deviceLimit = try container.decodeIfPresent(Int.self, forKey: .deviceLimit)
        show = decodeIntOrBool(from: container, key: .show)
        sort = try container.decodeIfPresent(Int.self, forKey: .sort)
        renew = decodeIntOrBool(from: container, key: .renew)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        monthPrice = try container.decodeIfPresent(Int.self, forKey: .monthPrice)
        quarterPrice = try container.decodeIfPresent(Int.self, forKey: .quarterPrice)
        halfYearPrice = try container.decodeIfPresent(Int.self, forKey: .halfYearPrice)
        yearPrice = try container.decodeIfPresent(Int.self, forKey: .yearPrice)
        twoYearPrice = try container.decodeIfPresent(Int.self, forKey: .twoYearPrice)
        threeYearPrice = try container.decodeIfPresent(Int.self, forKey: .threeYearPrice)
        onetimePrice = try container.decodeIfPresent(Int.self, forKey: .onetimePrice)
        resetPrice = try container.decodeIfPresent(Int.self, forKey: .resetPrice)
        resetTrafficMethod = try container.decodeIfPresent(String.self, forKey: .resetTrafficMethod)
        capacityLimit = try container.decodeIfPresent(Int.self, forKey: .capacityLimit)
        createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        _sellRaw = decodeIntOrBoolOptional(from: container, key: ._sellRaw)
    }
}
