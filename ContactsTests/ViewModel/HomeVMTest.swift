//
//  HomeVMTest.swift
//  ContactsTests
//
//  Created by sadman samee on 10/10/19.
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

class HomeVMTests: QuickSpec {
    override func spec() {
        describe("HomeVMTests") {

            var stubbingProvider: MoyaProvider<HomeService>!
            var sut: HomeVM!

            beforeEach {

                stubbingProvider = MoyaProvider<HomeService>(stubClosure: MoyaProvider.immediatelyStub)
                sut = HomeVM(homeProvider: stubbingProvider)
                sut.fetchContactss()
            }
            context("when initialized and data count is 10") {
                it("should load Contactss") {
                    let items = try! sut.cells.toBlocking().first()
                    expect(items?.count) == 10
                    expect(items?.count).toEventually(beGreaterThanOrEqualTo(10), timeout: 5)
                }

            }
        }
    }
}
