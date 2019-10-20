//
//  ContactDetailViewModelTest.swift
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
import SwiftyJSON

@testable import Contacts

class ContactDetailViewModelTest: QuickSpec {
    
    override func spec() {
        
        describe("ContactDetailViewModelTest") {
            var stubbingProvider: MoyaProvider<ContactService>!
            var sut: ContactDetailViewModel!
            let disposeBag = DisposeBag()
            afterEach {
                sut = nil
            }
            beforeEach {
                let path = Bundle.main.path(forResource: MockJson.contact.rawValue, ofType: "json")!
                let json = try! JSON(data: Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped))
                stubbingProvider = MoyaProvider<ContactService>(stubClosure: MoyaProvider.immediatelyStub)
                sut = ContactDetailViewModel(contactProvider: stubbingProvider,viewModel: Contact(fromJson: json) )
            }
            
            context("when initialized and data is okhay") {
                
                it("should load proper data") {
                    sut.onContactViewModel.asObservable().debug().subscribe(onNext: { result in
                        expect(result.name).toEventually(equal("Alexaaaaaa Amaz"), timeout: 5)
                        expect(result.isFavorite).toEventually(beTrue())
                        expect(result.profilePicUrl).toNot(beNil())
                    }
                    ).disposed(by: disposeBag)
                    
                }
            }
            
            context("when Deleting a Contact") {
                
                
                it("should delete successfully"){
                    
                    sut.onDeleteSuccess.asObservable().debug().subscribe({ result in
                        expect(result.element?.1).to(beTrue())
                        }
                    ).disposed(by: disposeBag)
                    
                    
                    sut.onAlertMessage.asObservable().debug().subscribe({  result in
                        expect(result.element).to(beNil())
                    }).disposed(by: disposeBag)
                    
                    sut.deleteButtonTapped.onNext(())
                }
            }
            
            
            
            
        }
    }
}
