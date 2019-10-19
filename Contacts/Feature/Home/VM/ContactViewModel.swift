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

}


extension Contact: ContactViewModel {
    var profilePicVM: String {
        return K.Url.base + profilePic
    }
    
    var contactVM: Contact {
        self
    }
    var name : String{
        return firstName + " " + lastName
    }
  
    
    var isFavorite: Bool {
           favorite
       }
    
}
