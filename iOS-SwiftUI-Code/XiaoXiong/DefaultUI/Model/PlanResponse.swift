//
//  PlanResponse.swift
//  SFI
//
//  Created by Mac on 2024/10/12.
//

import Foundation



// MARK: - Welcome
struct PlanResponse: Codable {
    let data: [DatuPlanResponse]?
    let message: String?
    let status: String?
    let error: String?
}

// MARK: - Datum
struct DatuPlanResponse: Codable, Identifiable {
    var id = UUID()
    let idOLD, groupID: Int?
    let transferEnable: Int?
    let name: String?
    let tags: [String]?
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
    let resetTrafficMethod: Int?
    let capacityLimit: Int?
    let createdAt, updatedAt: Int?

    /// sell 字段：API 可能返回 Int 或 Bool，用 isSell 访问布尔值
    private let _sellRaw: Int?
    var isSell: Bool { _sellRaw != 0 }

    enum CodingKeys: String, CodingKey {
        case idOLD = "id"
        case groupID = "group_id"
        case transferEnable = "transfer_enable"
        case name
        case tags
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
        idOLD = try container.decodeIfPresent(Int.self, forKey: .idOLD)
        groupID = try container.decodeIfPresent(Int.self, forKey: .groupID)
        transferEnable = try container.decodeIfPresent(Int.self, forKey: .transferEnable)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        tags = try container.decodeIfPresent([String].self, forKey: .tags)
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
        resetTrafficMethod = try container.decodeIfPresent(Int.self, forKey: .resetTrafficMethod)
        capacityLimit = try container.decodeIfPresent(Int.self, forKey: .capacityLimit)
        createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        _sellRaw = decodeIntOrBoolOptional(from: container, key: ._sellRaw)
    }
}
