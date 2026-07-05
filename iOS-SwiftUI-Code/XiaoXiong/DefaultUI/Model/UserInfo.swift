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
    }
    let data: Data?
}
