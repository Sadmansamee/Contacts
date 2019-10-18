//
//  TokenService.swift
//  Contacts
//
//  Created by sadman samee on 10/13/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

import SwiftyJSON

final class TokenService {
//    static let shared: TokenService = {
//        let instance = TokenService()
//        // Setup code
//        return instance
//    }()

    init() {
    }

    func getAcessToken() -> String {
        if let tok = UserDefaults.standard.value(forKey: "token"), let tokenString = tok as? String {
            return tokenString
        } else {
            return ""
        }
    }

    func setAcessToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }
}
