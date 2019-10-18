//
//	Contact.swift

import Foundation 
import SwiftyJSON

class Contact{

	var favorite : Bool!
	var firstName : String!
	var id : Int!
	var lastName : String!
	var profilePic : String!
	var url : String!


	/**
	 * Instantiate the instance using the passed json values to set the properties values
	 */
	init(fromJson json: JSON!){
		if json.isEmpty{
			return
		}
		favorite = json["favorite"].boolValue
		firstName = json["first_name"].stringValue
		id = json["id"].intValue
		lastName = json["last_name"].stringValue
		profilePic = json["profile_pic"].stringValue
		url = json["url"].stringValue
	}

}
