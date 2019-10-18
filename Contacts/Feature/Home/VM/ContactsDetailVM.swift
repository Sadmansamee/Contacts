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
    var homeProvider: MoyaProvider<HomeService>
    var contactViewModel: ContactViewModel

    private let _isLoading = BehaviorRelay(value: false)
    private let _alertMessage = PublishSubject<AlertMessage>()
    private let _contact = PublishSubject<Contact>()

    var onShowingLoading: Observable<Bool> {
        _isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onShowAlert: Observable<AlertMessage> {
        _alertMessage.asObservable()
    }

    var survey: Observable<Contact> {
        _contact.asObservable()
    }

    init(homeProvider: MoyaProvider<HomeService>, contactViewModel: ContactViewModel) {
        self.homeProvider = homeProvider
        self.contactViewModel = contactViewModel
        _contact.onNext(contactViewModel.contactVM)
    }
}
