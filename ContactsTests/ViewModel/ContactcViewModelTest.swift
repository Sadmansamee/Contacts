//
//  ContactcViewModelTest.swift
//  ContactsTests
//
//  Created by sadman samee on 10/20/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
import Nimble
import Quick
import RxBlocking
import RxSwift
import RxTest

@testable import Contacts

class ContactsViewModelTest: QuickSpec {
    override func spec() {
        describe("ContactsViewModelTest") {
            let disposeBag = DisposeBag()

            var stubbingProvider: MoyaProvider<ContactService>!
            var sut: ContactsViewModel!
            afterEach {
                sut = nil
            }
            beforeEach {
                stubbingProvider = MoyaProvider<ContactService>(stubClosure: MoyaProvider.immediatelyStub)
                sut = ContactsViewModel(contactProvider: stubbingProvider)
                sut.fetchContacts()
            }
            context("when initialized and data count okhay") {
                it("should load all the Contactss") {
                    let result = try! sut.onContactViewModels.toBlocking().first()
                    expect(result?.count).toEventually(beGreaterThanOrEqualTo(10), timeout: 5)
                }
                it("Grouping should start with 0 ends with Z") {
                    let result = try! sut.onContactViewModels.toBlocking().first()
                    expect(result?.first?.header).toNot(equal("A"))
                    expect(result?.first?.header).toEventually(equal("0"))
                    expect(result?.last?.header).toEventually(equal("z"))
                }
                it("Contacts First item should start with 0 and should end with Z") {
                    let result = try! sut.onContactViewModels.toBlocking().first()
                    expect(result?.first?.items.first?.firstName.first).toEventually(equal("0"))
                    expect(result?.first?.items.first?.firstName.first).toNot(equal("A"))
                    expect(result?.last?.items.first?.firstName.first).toEventually(equal("z"))
                }
                it("Loading should not show") {
                    sut.onLoading.asObservable().debug().subscribe(
                        onNext: { isLoading in
                            expect(isLoading).notTo(beTrue())
                        }
                    ).disposed(by: disposeBag)
                }
            }
        }
    }
}
