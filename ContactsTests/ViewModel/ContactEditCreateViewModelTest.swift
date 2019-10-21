//
//  ContactEditCreateViewModel.swift
//  ContactsTests
//
//  Created by sadman samee on 10/20/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
import Nimble
import Quick
import RxSwift
import SwiftyJSON

@testable import Contacts

class ContactEditCreateViewModelTest: QuickSpec {
    override func spec() {
        var stubbingProvider: MoyaProvider<ContactService>!
        let disposeBag = DisposeBag()

        describe("ContactEditCreateViewModelTest Edit") {
            var sut: ContactEditCreateViewModel!

            afterEach {
                sut = nil
            }
            beforeEach {
                let path = Bundle.main.path(forResource: MockJson.contact.rawValue, ofType: "json")!
                let json = try! JSON(data: Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped))
                stubbingProvider = MoyaProvider<ContactService>(stubClosure: MoyaProvider.immediatelyStub)
                sut = ContactEditCreateViewModel(contactProvider: stubbingProvider, viewModel: Contact(fromJson: json))
            }

            context("Field Validation Should Pass") {
                it("with data from ContactVM") {
                    sut.isValidAll.asObservable().debug().subscribe({ result in
                        expect(result.element).to(beTrue())
                    }
                    ).disposed(by: disposeBag)
                }
            }

            context("when initialized and data is okhay") {
                it("Editing Contact is Successfull") {
                    sut.onEditSuccess.asObservable().debug().subscribe({ result in
                        expect(result.element?.1).to(beTrue())
                    }
                    ).disposed(by: disposeBag)

                    sut.onAlertMessage.asObservable().debug().subscribe { result in
                        expect(result.element).to(beNil())
                    }.disposed(by: disposeBag)

                    sut.doneButtonTapped.onNext(())
                }
            }

            context("when Creating contact fails") {
                it("with empty data in Edit Mode") {
                    sut.onCreateSuccess.asObservable().debug().subscribe({ result in
                        expect(result.element?.1).toNot(beTrue())
                    }
                    ).disposed(by: disposeBag)

                    sut.onAlertMessage.asObservable().debug().subscribe { result in
                        expect(result.element).to(beNil())
                    }.disposed(by: disposeBag)

                    sut.doneButtonTapped.onNext(())
                }
            }
        }

        describe("ContactEditCreateViewModelTest Create") {
            var sut: ContactEditCreateViewModel!

            afterEach {
                sut = nil
            }
            beforeEach {
                stubbingProvider = MoyaProvider<ContactService>(stubClosure: MoyaProvider.immediatelyStub)
                sut = ContactEditCreateViewModel(contactProvider: stubbingProvider)
            }

            context("Field Validation Should Fail") {
                it("Validation should fail with empty") {
                    sut.isValidAll.asObservable().debug().subscribe({ result in
                        expect(result.element).toNot(beTrue())
                    }
                    ).disposed(by: disposeBag)
                }
            }

            context("Field Validation Should Pass") {
                it("Validation should pass with data from Field") {
                    sut.phoneNumber.accept("1234567890")
                    sut.firstName.accept("sadman")
                    sut.lastName.accept("samee")
                    sut.email.accept("sadman.dd@fm.dd")
                    sut.favorite.accept(true)

                    sut.isValidAll.asObservable().debug().subscribe({ result in
                        expect(result.element).to(beTrue())
                    }
                    ).disposed(by: disposeBag)
                }
            }

            context("when Editing contact should fail") {
                it("with empty data in create Mode") {
                    sut.onEditSuccess.asObservable().debug().subscribe({ result in
                        expect(result.element?.1).toNot(beTrue())
                    }
                    ).disposed(by: disposeBag)

                    sut.onAlertMessage.asObservable().debug().subscribe { result in
                        expect(result.element).toNot(beNil())
                    }.disposed(by: disposeBag)

                    sut.doneButtonTapped.onNext(())
                }
            }

            context("when Creating contact successfull") {
                it("Adding Contact should be Successfull") {
                    sut.phoneNumber.accept("01670139638")
                    sut.firstName.accept("sadman")
                    sut.lastName.accept("samee")
                    sut.email.accept("sadman.dd@fm.dd")
                    sut.favorite.accept(true)

                    sut.onCreateSuccess.asObservable().debug().subscribe({ result in
                        expect(result.element?.1).to(beTrue())
                    }
                    ).disposed(by: disposeBag)

                    sut.onAlertMessage.asObservable().debug().subscribe { result in
                        expect(result.element).to(beNil())
                    }.disposed(by: disposeBag)

                    sut.doneButtonTapped.onNext(())
                }
            }
        }
    }
}
