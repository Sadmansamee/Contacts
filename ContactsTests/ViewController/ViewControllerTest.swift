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
import RxSwift

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
        
        describe("ContactDetailVC") {
               var subject: ContactDetailVC!
                let disposeBag = DisposeBag()

               beforeEach {
                   subject = container.resolveViewController(ContactDetailVC.self)
                   _ = subject.view
               }

               context("when view is loaded") {
                   it("detail loaded") {

                    subject.viewModel.onContactViewModel.asObservable().debug().subscribe(onNext: { result in
                        expect(subject.labelName.text).to(equal("Alexaaaaaa Amaz"))
                        expect(subject.labelName.text).notTo(beEmpty())
                        expect(subject.imageViewFavourite.isHidden).to(beFalse())
                        }).disposed(by: disposeBag)
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
                    expect(subject.textFieldEmail.text).to(equal("ghhh@hhh.com"))
                    expect(subject.textFieldMobile.text).to(equal("0174481360000"))
                    expect(subject.btnDone.isEnabled).to(beTrue())
                }
            }
        }
    }
}
