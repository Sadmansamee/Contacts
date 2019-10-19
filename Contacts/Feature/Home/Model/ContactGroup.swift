//
//  ContactGroup.swift
//  Contacts
//
//  Created by sadman samee on 10/18/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import RxDataSources

struct ContactGroup {
  var header: String
  var items: [Item]
}
extension ContactGroup: SectionModelType {

  typealias Item = Contact
    
    var identity: String {
        return header
    }
    
   init(original: ContactGroup, items: [Item]) {
    self = original
    self.items = items
  }
}
