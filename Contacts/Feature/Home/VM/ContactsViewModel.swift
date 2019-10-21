//
//  HomeViewModel.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Moya
import RxRelay
import RxSwift
import SwiftyJSON

final class ContactsViewModel {
    // MARK: - Properties

    private var contactProvider: MoyaProvider<ContactService>

    private let isLoading = BehaviorRelay(value: false)

    private let alertMessage = PublishSubject<AlertMessage>()
    private let contactViewModels = BehaviorRelay<[ContactGroup]>(value: [])

    var onLoading: Observable<Bool> {
        isLoading.asObservable()
            .distinctUntilChanged()
    }

    var onAlertMessage: Observable<AlertMessage> {
        alertMessage.asObservable()
    }

    var onContactViewModels: Observable<[ContactGroup]> {
        contactViewModels.asObservable()
    }

    init(contactProvider: MoyaProvider<ContactService>) {
        self.contactProvider = contactProvider
        fetchContacts()
    }

    func contactDeleted(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)

        var oldValue = contactViewModels.value

        if let groupIndex = contactViewModels.value.firstIndex(where: { $0.header.elementsEqual(String(contact.firstName.first!)) }), let index = contactViewModels.value[groupIndex].items.firstIndex(where: { $0.id == contact.id }) {
            oldValue[groupIndex].items.remove(at: index)
        }
        contactViewModels.accept(oldValue)
    }

    func contactUpdated(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)

        var oldValue = contactViewModels.value

        if let groupIndex = contactViewModels.value.firstIndex(where: { $0.header.elementsEqual(String(contact.firstName.first!)) }), let index = contactViewModels.value[groupIndex].items.firstIndex(where: { $0.id == contact.id }) {
            oldValue[groupIndex].items[index] = contact
        }
        contactViewModels.accept(oldValue)
    }

    func contactAdded(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)

        var oldValue = contactViewModels.value

        if let groupIndex = oldValue.firstIndex(where: { $0.header.elementsEqual(String(contact.firstName.first!)) }) {
            oldValue[groupIndex].items.append(contact)
        }
        contactViewModels.accept(oldValue)
    }

    func fetchContacts() {
        isLoading.accept(true)

        contactProvider.request(.contacts, completion: { result in

            self.isLoading.accept(false)

            if case let .success(response) = result {
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()

                    let json = JSON(filteredResponse.data)

                    let contacts = json.arrayValue.compactMap {
                        Contact(fromJson: $0)
                    }

                    let groupedContacts = Dictionary(grouping: contacts, by: { String($0.firstName.first!) })
                    let contactGroups = groupedContacts.map { ContactGroup(header: $0.0, items: $0.1) }
                        .sorted { $0.header < $1.header }

                    self.contactViewModels.accept(contactGroups)

                } catch {
                    self.alertMessage.onNext(AlertMessage(title: error.localizedDescription, message: ""))
                }
            } else {
                self.alertMessage.onNext(AlertMessage(title: result.error?.errorDescription, message: ""))
            }
        })
    }
}
