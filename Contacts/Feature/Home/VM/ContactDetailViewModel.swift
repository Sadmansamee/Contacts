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

final class ContactDetailViewModel {
    // MARK: - Properties

    var contactProvider: MoyaProvider<ContactService>
    let disposeBag = DisposeBag()

    private let isLoading = BehaviorRelay(value: false)
    private let alertMessage = PublishSubject<AlertMessage>()
    private let contactViewModel = PublishSubject<ContactViewModel>()
    private let isDeleted = PublishSubject<(ContactViewModel, Bool)>()
    let deleteButtonTapped = PublishSubject<Void>()

    var onLoading: Observable<Bool> {
        isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onDeleteSuccess: Observable<(ContactViewModel, Bool)> {
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

        dump(viewModel)

        fetchContactDetail(viewModel: viewModel)

        deleteButtonTapped.asObserver()
            .subscribe(onNext: { [weak self] in

                guard let self = self else {
                    return
                }

                self.deleteContact(viewModel: viewModel)
            }).disposed(by: disposeBag)
    }

    func contactUpdated(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)
        contactViewModel.onNext(contact)
    }

    // MARK: - FUNCTIONS

    private func fetchContactDetail(viewModel: ContactViewModel) {
        isLoading.accept(true)

        contactProvider.request(.contactDetail(id: viewModel.contactVM.id), completion: { result in
            self.isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)
                    let contact = Contact(fromJson: json)
                    // contact.url = viewModel.contactVM.url
                    self.contactViewModel.onNext(contact)

                } catch {
                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self.alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }

    func deleteContact(viewModel: ContactViewModel) {
        isLoading.accept(true)

        contactProvider.request(.contactDelete(id: viewModel.contactVM.id), completion: { result in
            self.isLoading.accept(false)

            if case .success = result {
                // do {

                // TODO: - ON DELETE if deletion is successful there's no success message
                // or anything so if 200 received taking it as successfull

                // let filteredResponse = try response.filterSuccessfulStatusCodes()
                // let json = JSON(filteredResponse.data)
                self.isDeleted.onNext((viewModel, true))

//                } catch {
//                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
//                }
            } else {
                self.alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }
}
