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
    // MARK: - Properties

    var contactProvider: MoyaProvider<ContactService>
    let disposeBag = DisposeBag()

    private let isLoading = BehaviorRelay(value: false)
    private let alertMessage = PublishSubject<AlertMessage>()
    private let contactViewModel = PublishSubject<ContactViewModel>()
    private let isDeleted = PublishSubject<Bool>()
    let deleteButtonTapped = PublishSubject<Void>()

    var onLoading: Observable<Bool> {
        isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onDelete: Observable<Bool> {
        isDeleted.asObservable()
    }

    var onAlertMessage: Observable<AlertMessage> {
        alertMessage.asObservable()
    }

    var onContactViewModel: Observable<ContactViewModel> {
        contactViewModel.asObservable()
    }

    // MARK: - Init

    init(contactProvider: MoyaProvider<ContactService>, viewModel: ContactViewModel) {
        self.contactProvider = contactProvider
        contactViewModel.onNext(viewModel)
        if let url = viewModel.contactVM.url{
            fetchContactDetail(url: url)
        }
        deleteButtonTapped.asObserver()
            .subscribe(onNext: { [weak self] in
                self?.deleteContact(url: viewModel.contactVM.url)
            }).disposed(by: disposeBag)
    }

    func contactUpdated(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)
        contactViewModel.onNext(contact)
    }

    // MARK: - FUNCTIONS

    private func fetchContactDetail(url: String) {
        isLoading.accept(true)

        contactProvider.request(.contactDetail(url: url), completion: { result in
            self.isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)
                    var contact = Contact(fromJson: json)
                    contact.url = url
                    self.contactViewModel.onNext(contact)

                } catch {
                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self.alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }

    func deleteContact(url: String) {
        isLoading.accept(true)

        contactProvider.request(.contactDelete(url: url), completion: { result in
            self.isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    // ON DELETE if deletion is successful there's no success message or anything so if 200 received taking it as successfull
                    // let filteredResponse = try response.filterSuccessfulStatusCodes()
                    // let json = JSON(filteredResponse.data)
                    self.isDeleted.onNext(true)

                } catch {
                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self.alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }
}
