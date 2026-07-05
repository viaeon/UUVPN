//
//  File.swift
//  SFI
//
//  Created by Mac on 2024/10/21.
//

import Foundation

// MARK: - OrderInfoReponse
struct OrderInfoReponse: Codable {
    let status, message: String?
    let data: [OrderInfoDatum]?
}

struct OrderInfoSingleReponse: Codable {
    let status, message: String?
    let data: OrderInfoDatum?
}


// MARK: - Datum
struct OrderInfoDatum: Codable ,Identifiable {
    var id = UUID().uuidString
    let inviteUserID: String?
    let planID: Int?
    let siteID, couponID: String?
    let type: Int?
    let period: String?
    let couponCode: String?
    let tradeNo: String?
    let callbackNo: String?
    let totalAmount: Double?
    let handlingAmount, discountAmount, surplusAmount, refundAmount: Double?
    let balanceAmount, surplusOrderIDS,paymentID: Int?
    let status: Int?
    let createdAt, updatedAt: Int?
    let commissionStatus, commissionBalance: Int?
    let tixianstatus: String?
    let plan: PlanOrder?

    var status_zh: String {
        switch status {
        case 0:
            return "待支付"
        case 1:
            return "已支付"
        case 2:
            return "已取消"
        default:
            return "未知"
        }
    }

    var period_zh: String {
        switch period {
        case "month_price":
            return "月付"
        case "quarter_price":
            return "季付"
        case "half_year_price":
            return "半年付"
        case "year_price":
            return "年付"
        default:
            return "月付"
        }
    }

    enum CodingKeys: String, CodingKey {
        case inviteUserID = "invite_user_id"
        case planID = "plan_id"
        case siteID = "site_id"
        case couponID = "coupon_id"
        case paymentID = "payment_id"
        case type, period
        case couponCode = "coupon_code"
        case tradeNo = "trade_no"
        case callbackNo = "callback_no"
        case totalAmount = "total_amount"
        case handlingAmount = "handling_amount"
        case discountAmount = "discount_amount"
        case surplusAmount = "surplus_amount"
        case refundAmount = "refund_amount"
        case balanceAmount = "balance_amount"
        case surplusOrderIDS = "surplus_order_ids"
        case status
        case commissionStatus = "commission_status"
        case commissionBalance = "commission_balance"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case tixianstatus, plan
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        inviteUserID = try container.decodeIfPresent(String.self, forKey: .inviteUserID)
        planID = try container.decodeIfPresent(Int.self, forKey: .planID)
        siteID = try container.decodeIfPresent(String.self, forKey: .siteID)
        couponID = try container.decodeIfPresent(String.self, forKey: .couponID)
        type = try container.decodeIfPresent(Int.self, forKey: .type)
        period = try container.decodeIfPresent(String.self, forKey: .period)
        couponCode = try container.decodeIfPresent(String.self, forKey: .couponCode)
        tradeNo = try container.decodeIfPresent(String.self, forKey: .tradeNo)
        callbackNo = try container.decodeIfPresent(String.self, forKey: .callbackNo)
        totalAmount = try container.decodeIfPresent(Double.self, forKey: .totalAmount)
        handlingAmount = try container.decodeIfPresent(Double.self, forKey: .handlingAmount)
        discountAmount = try container.decodeIfPresent(Double.self, forKey: .discountAmount)
        surplusAmount = try container.decodeIfPresent(Double.self, forKey: .surplusAmount)
        refundAmount = try container.decodeIfPresent(Double.self, forKey: .refundAmount)
        balanceAmount = try container.decodeIfPresent(Int.self, forKey: .balanceAmount)
        surplusOrderIDS = try container.decodeIfPresent(Int.self, forKey: .surplusOrderIDS)
        paymentID = try container.decodeIfPresent(Int.self, forKey: .paymentID)
        status = try container.decodeIfPresent(Int.self, forKey: .status)
        commissionStatus = try container.decodeIfPresent(Int.self, forKey: .commissionStatus)
        commissionBalance = try container.decodeIfPresent(Int.self, forKey: .commissionBalance)
        createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        tixianstatus = try container.decodeIfPresent(String.self, forKey: .tixianstatus)
        plan = try container.decodeIfPresent(PlanOrder.self, forKey: .plan)
    }
}

// MARK: - Plan
struct PlanOrder: Codable {
    let id: Int?
    let name: String?
    let speedLimit: Int?
    let show: Int
    let sort: Int?
    let renew: Int
    let groupID: Int?
    let transferEnable: Int?
    let content: String?
    let monthPrice, quarterPrice, halfYearPrice, yearPrice: Int?
    let twoYearPrice, threeYearPrice, onetimePrice, resetPrice: Double?
    let resetTrafficMethod: Int?
    let capacityLimit: Int?
    let createdAt, updatedAt: Int?

    /// sell 字段：API 可能返回 Int 或 Bool
    private let _sellRaw: Int?
    var isSell: Bool { _sellRaw != 0 }

    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case transferEnable = "transfer_enable"
        case name
        case speedLimit = "speed_limit"
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
        name = try container.decodeIfPresent(String.self, forKey: .name)
        speedLimit = try container.decodeIfPresent(Int.self, forKey: .speedLimit)
        show = decodeIntOrBool(from: container, key: .show)
        sort = try container.decodeIfPresent(Int.self, forKey: .sort)
        renew = decodeIntOrBool(from: container, key: .renew)
        groupID = try container.decodeIfPresent(Int.self, forKey: .groupID)
        transferEnable = try container.decodeIfPresent(Int.self, forKey: .transferEnable)
        content = try container.decodeIfPresent(String.self, forKey: .content)
        monthPrice = try container.decodeIfPresent(Int.self, forKey: .monthPrice)
        quarterPrice = try container.decodeIfPresent(Int.self, forKey: .quarterPrice)
        halfYearPrice = try container.decodeIfPresent(Int.self, forKey: .halfYearPrice)
        yearPrice = try container.decodeIfPresent(Int.self, forKey: .yearPrice)
        twoYearPrice = try container.decodeIfPresent(Double.self, forKey: .twoYearPrice)
        threeYearPrice = try container.decodeIfPresent(Double.self, forKey: .threeYearPrice)
        onetimePrice = try container.decodeIfPresent(Double.self, forKey: .onetimePrice)
        resetPrice = try container.decodeIfPresent(Double.self, forKey: .resetPrice)
        resetTrafficMethod = try container.decodeIfPresent(Int.self, forKey: .resetTrafficMethod)
        capacityLimit = try container.decodeIfPresent(Int.self, forKey: .capacityLimit)
        createdAt = try container.decodeIfPresent(Int.self, forKey: .createdAt)
        updatedAt = try container.decodeIfPresent(Int.self, forKey: .updatedAt)
        _sellRaw = decodeIntOrBoolOptional(from: container, key: ._sellRaw)
    }
}
