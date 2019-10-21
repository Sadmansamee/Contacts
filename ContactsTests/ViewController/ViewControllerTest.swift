//
//  HomeVCTest.swift
//  ContactsTests
//
//  Created by sadman samee on 10/12/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

@testable import Contacts
import Nimble
import Quick
import Swinject
import XCTest

class ViewControllerTest: QuickSpec {
    override func spec() {
        let container = setupDependencies()

        describe("ContactsVC") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    container.resolveViewController(ContactsVC.self)
                }

                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("ContactDetailVC") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    container.resolveViewController(ContactDetailVC.self)
                }

                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("ContactEditCreateVC") {
            describe("viewDidLoad") {
                let vc = LeakTest {
                    container.resolveViewController(ContactEditCreateVC.self)
                }

                it("must not leak") {
                    expect(vc).toNot(leak())
                }
            }
        }

        describe("ContactsVC") {
            var subject: ContactsVC!

            beforeEach {
                subject = container.resolveViewController(ContactsVC.self)
                _ = subject.view
            }

            context("when view is loaded") {
                it("should have contacts loaded") {
                    expect(subject.tableView.numberOfRows(inSection: 0)).to(beGreaterThan(2))
                }
            }
        }

        describe("ContactEditCreateVC") {
            var subject: ContactEditCreateVC!

            beforeEach {
                subject = container.resolveViewController(ContactEditCreateVC.self)
                _ = subject.view
            }

            context("when view is loaded") {
                it("should have Contact data loaded in Edit Mode") {
                    expect(subject.textFieldFirstName.text).to(equal("Alexaaaaaa"))
                    expect(subject.textFieldLastName.text).to(equal("Amaz"))
                }
            }
        }
    }
}
