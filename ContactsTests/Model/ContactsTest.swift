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
import RxBlocking
import RxSwift
import RxTest
import SwiftyJSON

@testable import Contacts

class ContactsTest: QuickSpec {
    override func spec() {
        describe("ContactsTest") {
            var json: JSON!

            beforeEach {
                if let path = Bundle.main.path(forResource: MockJson.Contacts.rawValue, ofType: "json") {
                    let url = URL(fileURLWithPath: path)
                    json = try? JSON(data: Data(contentsOf: url))
                }
            }
            context("Model From Json") {
                var survey: Contacts!
                beforeEach {
                    survey = Contacts(fromJson: json)
                }

                it("Data is valid") {
                    expect(survey).toNot(beNil())
                    expect(survey?.title).toNot(beNil())
                }
            }
        }
    }
}
