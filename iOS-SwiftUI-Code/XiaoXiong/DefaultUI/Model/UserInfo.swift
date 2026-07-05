//
//  UserInfo.swift
//  LoginKit
//
//  Created by Mac on 2024/10/12.
//

import Foundation
struct UserInfo: Codable {
    struct Data: Codable {
        let email: String?
        let transfer_enable: Int?
        let device_limit: Int?
        let last_login_at: Int?
        let created_at: Int?
        let banned: Int?
        let remind_expire: Int?
        let remind_traffic: Int?
        let expired_at: Int?
        let balance: Double?
        let commission_balance: Double?
        let plan_id: Int?
        let discount: Int?
        let commission_rate: Int?
        let telegram_id: Int?
        let uuid: String?
        let avatar_url: String?
        let invite_code: String?
        let invite_user_id: Int?
        let risk: Int?

        enum CodingKeys: String, CodingKey {
            case email, transfer_enable, device_limit, last_login_at, created_at
            case banned, remind_expire, remind_traffic, expired_at
            case balance, commission_balance, plan_id, discount, commission_rate
            case telegram_id, uuid, avatar_url, invite_code, invite_user_id, risk
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            email = try container.decodeIfPresent(String.self, forKey: .email)
            transfer_enable = try container.decodeIfPresent(Int.self, forKey: .transfer_enable)
            device_limit = try container.decodeIfPresent(Int.self, forKey: .device_limit)
            last_login_at = try container.decodeIfPresent(Int.self, forKey: .last_login_at)
            created_at = try container.decodeIfPresent(Int.self, forKey: .created_at)
            banned = decodeIntOrBoolOptional(from: container, key: .banned)
            remind_expire = decodeIntOrBoolOptional(from: container, key: .remind_expire)
            remind_traffic = decodeIntOrBoolOptional(from: container, key: .remind_traffic)
            expired_at = try container.decodeIfPresent(Int.self, forKey: .expired_at)
            balance = try container.decodeIfPresent(Double.self, forKey: .balance)
            commission_balance = try container.decodeIfPresent(Double.self, forKey: .commission_balance)
            plan_id = try container.decodeIfPresent(Int.self, forKey: .plan_id)
            discount = try container.decodeIfPresent(Int.self, forKey: .discount)
            commission_rate = try container.decodeIfPresent(Int.self, forKey: .commission_rate)
            telegram_id = try container.decodeIfPresent(Int.self, forKey: .telegram_id)
            uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
            avatar_url = try container.decodeIfPresent(String.self, forKey: .avatar_url)
            invite_code = try container.decodeIfPresent(String.self, forKey: .invite_code)
            invite_user_id = try container.decodeIfPresent(Int.self, forKey: .invite_user_id)
            risk = try container.decodeIfPresent(Int.self, forKey: .risk)
        }
    }
    let data: Data?
    let status: String?
    let message: String?
    let error: String?
}
