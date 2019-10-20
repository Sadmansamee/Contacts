//
//	Contact.swift

import Foundation
import SwiftyJSON

struct Contact {
    var favorite: Bool!
    var firstName: String!
    var id: Int!
    var lastName: String!
    var profilePic: String!
    var url: String!

    var email: String!
    var phoneNumber: String!

    /**
     * Instantiate the instance using the passed json values to set the properties values
     */
    init(fromJson json: JSON!) {
        if json.isEmpty {
            return
        }
        favorite = json["favorite"].boolValue
        firstName = json["first_name"].stringValue
        id = json["id"].intValue
        lastName = json["last_name"].stringValue
        profilePic = json["profile_pic"].stringValue
        if let url = json["url"].string {
            self.url = url
        }
        email = json["email"].stringValue
        phoneNumber = json["phone_number"].stringValue
    }

    func toDictionary() -> [String: Any] {
        var dictionary = [String: Any]()

        if email != nil {
            dictionary["email"] = email
        }
        if favorite != nil {
            dictionary["favorite"] = favorite
        }
        if firstName != nil {
            dictionary["first_name"] = firstName
        }
        if id != nil {
            dictionary["id"] = id
        }
        if lastName != nil {
            dictionary["last_name"] = lastName
        }
        if phoneNumber != nil {
            dictionary["phone_number"] = phoneNumber
        }
        if profilePic != nil {
            dictionary["profile_pic"] = profilePic
        }

        if url != nil {
            dictionary["url"] = url
        }

        return dictionary
    }
}
