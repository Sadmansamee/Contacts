//
//  HomeVCTest.swift
//  ContactsTests
//
//  Created by sadman samee on 10/12/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

@testable import Contacts
import Quick
import Swinject
import XCTest
import Nimble

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
    }
}
