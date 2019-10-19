//
//  HomeService.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Moya

public enum ContactService {
    case contacts
    case contactDetail(url: String)
}

extension ContactService: TargetType {
    public var baseURL: URL {
        switch self {
               case let .contactDetail(url):
                   return URL(string: url)!
               default:
                   return URL(string: K.Url.base)!
               }
    }

    public var path: String {
        switch self {
        case .contacts:
            return "contacts.json"
        case .contactDetail:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .contacts,.contactDetail:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .contacts,.contactDetail:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .contacts,.contactDetail:
            return ["Content-Type": "application/json; charset=utf-8"]
        }
    }

    public var authorizationType: AuthorizationType {
        switch self {
        case .contacts,.contactDetail:
            return .none
        }
    }

    public var validationType: ValidationType {
        switch self {
        case .contacts,.contactDetail:
            return .successCodes
        }
    }

    public var sampleData: Data {
        switch self {
        case .contacts:

            guard let path = Bundle.main.path(forResource: MockJson.Contacts.rawValue, ofType: "json") else {
                return "".data(using: String.Encoding.utf8)!
            }
            let url = URL(fileURLWithPath: path)
            do {
                return try Data(contentsOf: url, options: .mappedIfSafe)
            } catch {
                return "".data(using: String.Encoding.utf8)!
            }
            
        case .contactDetail:
            guard let path = Bundle.main.path(forResource: MockJson.Contacts.rawValue, ofType: "json") else {
                           return "".data(using: String.Encoding.utf8)!
                       }
                       let url = URL(fileURLWithPath: path)
                       do {
                           return try Data(contentsOf: url, options: .mappedIfSafe)
                       } catch {
                           return "".data(using: String.Encoding.utf8)!
                       }
        }
    }
}
