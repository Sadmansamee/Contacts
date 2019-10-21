//
//  ContactGroupTest.swift
//  ContactsTests
//
//  Created by sadman samee on 10/20/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Nimble
import Quick
import RxSwift
import SwiftyJSON

@testable import Contacts

class ContactGroupTest: QuickSpec {
    override func spec() {
        describe("ContactGroupTest") {
            var json: JSON!
            var sut: [ContactGroup]!

            afterEach {
                sut = nil
            }
            beforeEach {
                if let path = Bundle.main.path(forResource: MockJson.contacts.rawValue, ofType: "json") {
                    let url = URL(fileURLWithPath: path)
                    json = try? JSON(data: Data(contentsOf: url))

                    let contacts = json.arrayValue.compactMap {
                        Contact(fromJson: $0)
                    }
                    let groupedContacts = Dictionary(grouping: contacts, by: { String($0.firstName.first!) })

                    sut = groupedContacts.map { ContactGroup(header: $0.0, items: $0.1) }
                        .sorted { $0.header < $1.header }
                }
            }
            context("Model From Json") {
                it("Grouping should start with 0 ends with Z") {
                    expect(sut.first?.header).toEventually(equal("0"))
                    expect(sut.first?.header).toNot(equal("A"))
                    expect(sut.last?.header).toEventually(equal("z"))
                    expect(sut.last?.header).toNot(equal("B"))
                }
                it("Contacts First item should start with 0 and should end with Z") {
                    expect(sut.first?.items.first?.firstName.first).toEventually(equal("0"))
                    expect(sut.first?.items.first?.firstName.first).toNot(equal("A"))
                    expect(sut.last?.items.first?.firstName.first).toEventually(equal("z"))
                    expect(sut.last?.items.first?.firstName.first).toNot(equal("B"))
                }
            }
        }
    }
}
