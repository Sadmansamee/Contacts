//
//  HomeService.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Moya

public enum HomeService {
    case contacts
}

extension HomeService: TargetType {
    public var baseURL: URL {
        URL(string: K.Url.base)!
    }

    public var path: String {
        switch self {
        case .contacts:
            return "contacts.json"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .contacts:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .contacts:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        switch self {
        case .contacts:
            return ["Content-Type": "application/json; charset=utf-8"]
        }
    }

    public var authorizationType: AuthorizationType {
        switch self {
        case .contacts:
            return .none
        }
    }

    public var validationType: ValidationType {
        switch self {
        case .contacts:
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
        }
    }
}
