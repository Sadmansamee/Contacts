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
            var vm: HomeVM!

            beforeEach {

                let tokenClosure: () -> String = {
                    return "84bf8bcc4c2286a201b9a8ceca18f5dcb3295e5d22dcee805488eca63ef01b53"
                }

                stubbingProvider = MoyaProvider<HomeService>(stubClosure: MoyaProvider.immediatelyStub, plugins: [AccessTokenPlugin(tokenClosure: tokenClosure)])
                vm = HomeVM(homeProvider: stubbingProvider)
                vm.fetchContactss()
            }
            context("when initialized and data count is 10") {
                it("should load Contactss") {
                    let surveys = try! vm.cells.toBlocking().first()
                    expect(surveys?.count) == 10
                    expect(surveys?.count).toEventually(beGreaterThanOrEqualTo(10), timeout: 5)
                    expect(surveys?.first?.0.titleVM).to(equal("Scarlett Bangkok"))
                }

            }
        }
    }
}
