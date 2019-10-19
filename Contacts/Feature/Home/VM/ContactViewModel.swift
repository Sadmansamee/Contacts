//
//  ContactsViewModel.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

protocol ContactViewModel {
    var contactVM: Contact { get }
    var name: String {get}
    var isFavorite: Bool {get}
    var profilePicVM: String {get}
    var emailVM: String {get}
    var phoneNumberVM: String {get}

}


extension Contact: ContactViewModel {
    
    var emailVM: String {
        email
    }
    
    var phoneNumberVM: String {
        phoneNumber
    }
    
    var profilePicVM: String {
        K.Url.base + profilePic
    }
    
    var contactVM: Contact {
        self
    }
    var name : String{
         firstName + " " + lastName
    }
  
    var isFavorite: Bool {
        favorite
    }
    
}
