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
    case contactDetail(id: Int)
    case contactCreate(firstName: String, lastName: String, email: String,
                       phoneNumber: String, favorite: Bool)
    case contactUpdate(id: Int, firstName: String, lastName: String,
                       email: String, phoneNumber: String, favorite: Bool)
    case contactDelete(id: Int)
}

extension ContactService: TargetType {
    public var baseURL: URL {
        return URL(string: Constant.Url.base)!
//        switch self {
//        case  let .contactDelete(url):
//            return URL(string: url)!
//        default:
//            return URL(string: Constant.Url.base)!
//        }
    }

    public var path: String {
        switch self {
        case .contacts, .contactCreate:
            return "contacts.json"
        case let .contactDetail(id), let .contactUpdate(id, _, _, _, _, _), let .contactDelete(id):
            return "contacts/\(id).json"
//        case .contactDelete:
//            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .contacts, .contactDetail:
            return .get
        case .contactCreate:
            return .post
        case .contactUpdate:
            return .put
        case .contactDelete:
            return .delete
        }
    }

    public var task: Task {
        switch self {
        case .contacts, .contactDetail, .contactDelete:
            return .requestPlain
        case let .contactCreate(firstName, lastName, email, phoneNumber, favorite):
            return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName, "email": email, "phoneNumber": phoneNumber, "favorite": favorite], encoding: JSONEncoding.default)
        case let .contactUpdate(_, firstName, lastName, email, phoneNumber, favorite):
            return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName, "email": email, "phoneNumber": phoneNumber, "favorite": favorite], encoding: JSONEncoding.default)
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json; charset=utf-8"]
    }

    public var authorizationType: AuthorizationType {
        return .none
    }

    public var validationType: ValidationType {
        return .successCodes
    }

    public var sampleData: Data {
        switch self {
        case .contacts:

            guard let path = Bundle.main.path(forResource: MockJson.contacts.rawValue, ofType: "json") else {
                return "".data(using: String.Encoding.utf8)!
            }
            let url = URL(fileURLWithPath: path)
            do {
                return try Data(contentsOf: url, options: .mappedIfSafe)
            } catch {
                return "".data(using: String.Encoding.utf8)!
            }

        case .contactDetail, .contactDelete, .contactUpdate, .contactCreate:
            guard let path = Bundle.main.path(forResource: MockJson.contact.rawValue, ofType: "json") else {
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
