//
//  ContactEditCreateViewModel.swift
//  Contacts
//
//  Created by sadman samee on 10/19/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Moya
import RxRelay
import RxSwift
import SwiftyJSON

final class ContactEditCreateViewModel {
    enum TaskMode {
        case update
        case create
    }

    var contactProvider: MoyaProvider<ContactService>
    let disposeBag = DisposeBag()

    init(contactProvider: MoyaProvider<ContactService>, viewModel: ContactViewModel? = nil) {
        self.contactProvider = contactProvider
        taskMode = .create

        if let contactViewModel = viewModel {
            email.accept(contactViewModel.contactVM.email)
            phoneNumber.accept(contactViewModel.contactVM.phoneNumber)
            firstName.accept(contactViewModel.contactVM.firstName)
            lastName.accept(contactViewModel.contactVM.lastName)
            favorite.accept(contactViewModel.contactVM.favorite)
            url = contactViewModel.contactVM.url
            taskMode = .update
        }

        doneButtonTapped.asObserver()
            .subscribe(onNext: { [weak self] in
                self?.updateCreateContact()
            }).disposed(by: disposeBag)
    }

    private let isLoading = BehaviorRelay(value: false)
    private let alertMessage = PublishSubject<AlertMessage>()
    private let contactViewModel = PublishSubject<ContactViewModel>()
    private let isSuccess = PublishSubject<(ContactViewModel, Bool)>()

    private var taskMode: TaskMode!

    let doneButtonTapped = PublishSubject<Void>()

    var onSuccess: Observable<(ContactViewModel, Bool)> {
        isSuccess.asObservable()
    }

    var onLoading: Observable<Bool> {
        isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onAlertMessage: Observable<AlertMessage> {
        alertMessage.asObservable()
    }

    var url: String!
    var email = BehaviorRelay<String>(value: "")
    var phoneNumber = BehaviorRelay<String>(value: "")
    var firstName = BehaviorRelay<String>(value: "")
    var lastName = BehaviorRelay<String>(value: "")
    var favorite = BehaviorRelay<Bool>(value: false)

    private var isFirstnameValid: Observable<Bool> {
        return firstName.asObservable().map { $0.count > 3 }
    }

    private var isLastnameValid: Observable<Bool> {
        return lastName.asObservable().map { $0.count > 3 }
    }

    private var isPhoneNumberValid: Observable<Bool> {
        return phoneNumber.asObservable().map { $0.count > 6 }
    }

    private var isEmailValid: Observable<Bool> {
        return email.asObservable().map { $0.count > 6 }
    }

    var isValidAll: Observable<Bool> {
        return Observable.combineLatest(isFirstnameValid,
                                        isLastnameValid,
                                        isPhoneNumberValid,
                                        isEmailValid) { $0 && $1 && $2 && $3 }
    }

    private func updateCreateContact() {
        switch taskMode {
        case .create:
            createContact()
        case .update:
            updateContact()
        default:
            break
        }
    }

    private func createContact() {
        isLoading.accept(true)
        contactProvider.request(.contactCreate(firstName: firstName.value,
                                               lastName: lastName.value,
                                               email: email.value,
                                               phoneNumber: phoneNumber.value,
                                               favorite: favorite.value),
                                completion: { result in
            self.isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)
                    let contact = Contact(fromJson: json)
                    self.isSuccess.onNext((contact, true))

                } catch {
                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self.alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }

    private func updateContact() {
        isLoading.accept(true)

        contactProvider.request(.contactUpdate(url: url,
                                               firstName: firstName.value,
                                               lastName: lastName.value,
                                               email: email.value,
                                               phoneNumber: phoneNumber.value,
                                               favorite: favorite.value),
                                completion: { result in
            self.isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)
                    let contact = Contact(fromJson: json)
                    self.isSuccess.onNext((contact, true))

                } catch {
                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self.alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }
}
