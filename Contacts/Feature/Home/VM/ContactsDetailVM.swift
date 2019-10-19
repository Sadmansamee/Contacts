//
//  ContactsDetailVM.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

import Moya
import RxRelay
import RxSwift
import SwiftyJSON



final class ContactsDetailVM {
    
    var homeProvider: MoyaProvider<ContactService>

   private let _isLoading = BehaviorRelay(value: false)
    private let _alertMessage = PublishSubject<AlertMessage>()
    //private let _contact = PublishSubject<Contact>()
    private let _contactViewModel = PublishSubject<ContactViewModel>()


    var isLoading: Observable<Bool> {
        _isLoading.asObservable()
            .distinctUntilChanged()
    }

    var alertMessage: Observable<AlertMessage> {
        _alertMessage.asObservable()
    }

    var contactViewModel: Observable<ContactViewModel> {
        _contactViewModel.asObservable()
    }

    init(homeProvider: MoyaProvider<ContactService>, contactViewModel: ContactViewModel) {
        self.homeProvider = homeProvider
        _contactViewModel.onNext(contactViewModel)
        fetchContactDetail(url: contactViewModel.contactVM.url)
    }
    
    func fetchContactDetail(url: String) {
         _isLoading.accept(true)

         homeProvider.request(.contactDetail(url: url), completion: { result in
             self._isLoading.accept(false)

             if case let .success(response) = result {
                 do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)
                    let contactDetail = Contact(fromJson: json)
                    self._contactViewModel.onNext(contactDetail)

                 } catch {
                     self._alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                 }
             } else {
                 self._alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
             }
         })
     }
    
}
