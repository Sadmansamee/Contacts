//
//  ContactsTest.swift
//  ContactsTests
//
//  Created by sadman samee on 10/10/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Nimble
import Quick
import RxSwift
import SwiftyJSON

@testable import Contacts

class ContactTest: QuickSpec {
    override func spec() {
        describe("ContactTest") {
            var json: JSON!

            beforeEach {
                if let path = Bundle.main.path(forResource: MockJson.contact.rawValue, ofType: "json") {
                    let url = URL(fileURLWithPath: path)
                    json = try? JSON(data: Data(contentsOf: url))
                }
            }
            context("Model From Json") {
                var sut: Contact!
                afterEach {
                    sut = nil
                }
                beforeEach {
                    sut = Contact(fromJson: json)
                }

                it("Data is valid") {
                    expect(sut).toNot(beNil())
                    expect(sut?.firstName).toNot(beNil())
                    expect(sut?.firstName).to(equal("Alexaaaaaa"))
                    expect(sut?.url).toNot(beNil())
                    expect(sut?.profilePic).toNot(beNil())
                }
            }
        }
    }
}
