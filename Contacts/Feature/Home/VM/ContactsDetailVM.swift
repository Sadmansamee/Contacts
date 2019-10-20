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
    var contactProvider: MoyaProvider<ContactService>

    private let isLoading = BehaviorRelay(value: false)
    private let alertMessage = PublishSubject<AlertMessage>()
    private let contactViewModel = PublishSubject<ContactViewModel>()

    var onLoading: Observable<Bool> {
        isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onAlertMessage: Observable<AlertMessage> {
        alertMessage.asObservable()
    }

    var onContactViewModel: Observable<ContactViewModel> {
        contactViewModel.asObservable()
    }

    init(contactProvider: MoyaProvider<ContactService>, viewModel: ContactViewModel) {
        self.contactProvider = contactProvider
        contactViewModel.onNext(viewModel)
        fetchContactDetail(url: viewModel.contactVM.url)
    }

    func fetchContactDetail(url: String) {
        isLoading.accept(true)

        contactProvider.request(.contactDetail(url: url), completion: { result in
            self.isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)
                    let contactDetail = Contact(fromJson: json)
                    self.contactViewModel.onNext(contactDetail)

                } catch {
                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self.alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }
}
