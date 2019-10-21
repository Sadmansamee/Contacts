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

    // MARK: - Properties

    var contactProvider: MoyaProvider<ContactService>
    let disposeBag = DisposeBag()
    private var taskMode: TaskMode!

    private let isLoading = BehaviorRelay(value: false)
    private let alertMessage = PublishSubject<AlertMessage>()
    private let contactViewModel = PublishSubject<ContactViewModel>()
    private let isCreateSuccess = PublishSubject<(ContactViewModel, Bool)>()
    private let isEditSuccess = PublishSubject<(ContactViewModel, Bool)>()

    var id: Int!

    var email = BehaviorRelay<String>(value: "")
    var phoneNumber = BehaviorRelay<String>(value: "")
    var firstName = BehaviorRelay<String>(value: "")
    private var imageUrl = BehaviorRelay<String>(value: "")
    var lastName = BehaviorRelay<String>(value: "")
    var favorite = BehaviorRelay<Bool>(value: false)

    let doneButtonTapped = PublishSubject<Void>()

    var onCreateSuccess: Observable<(ContactViewModel, Bool)> {
        isCreateSuccess.asObservable()
    }

    var onEditSuccess: Observable<(ContactViewModel, Bool)> {
        isEditSuccess.asObservable()
    }

    var onLoading: Observable<Bool> {
        isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onImageUrl: Observable<String> {
        imageUrl.asObservable()
            .distinctUntilChanged()
    }

    var onAlertMessage: Observable<AlertMessage> {
        alertMessage.asObservable()
    }

    // MARK: - Validation

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
        return email.asObservable().map { $0.count > 6 && $0.isvalidEmail }
    }

    var isValidAll: Observable<Bool> {
        return Observable.combineLatest(isFirstnameValid,
                                        isLastnameValid,
                                        isPhoneNumberValid,
            isEmailValid) { $0 && $1 && $2 && $3 }.distinctUntilChanged()
    }

    // MARK: - INIT

    init(contactProvider: MoyaProvider<ContactService>, viewModel: ContactViewModel? = nil) {
        self.contactProvider = contactProvider
        taskMode = .create

        if let contactViewModel = viewModel {
            email.accept(contactViewModel.contactVM.email)
            phoneNumber.accept(contactViewModel.contactVM.phoneNumber)
            firstName.accept(contactViewModel.contactVM.firstName)
            lastName.accept(contactViewModel.contactVM.lastName)
            favorite.accept(contactViewModel.contactVM.favorite)
            id = contactViewModel.contactVM.id
            imageUrl.accept(contactViewModel.contactVM.profilePicUrl)
            taskMode = .update
        }

        doneButtonTapped.asObserver()
            .subscribe(onNext: { [weak self] in
                self?.updateCreateContact()
            }).disposed(by: disposeBag)
    }

    // MARK: - Private functions

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
                                            self.isCreateSuccess.onNext((contact, true))
                                        } catch {
                                            self.alertMessage.onNext(
                                                AlertMessage(title: error.localizedDescription, message: ""))
                                        }
                                    } else {
                                        self.alertMessage.onNext(
                                            AlertMessage(title: result.error?.errorDescription, message: ""))
                                    }
        })
    }

    private func updateContact() {
        isLoading.accept(true)

        contactProvider.request(.contactUpdate(id: id,
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
                                            // contact.url = self.url
                                            self.isEditSuccess.onNext((contact, true))

                                        } catch {
                                            self.alertMessage.onNext(
                                                AlertMessage(title: error.localizedDescription, message: ""))
                                        }
                                    } else {
                                        self.alertMessage.onNext(
                                            AlertMessage(title: result.error?.errorDescription, message: ""))
                                    }
        })
    }
}
