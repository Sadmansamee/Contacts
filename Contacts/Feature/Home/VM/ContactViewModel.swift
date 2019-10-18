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
  
}

extension Contact: ContactViewModel {
    var contactVM: Contact {
        self
    }

}
