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
    }

    func contactUpdated(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)

        // contactViewModels.value.filter { $0.header.elementsEqual(String(contact.firstName.first!))}.first?.items.filter { $0.id == contact.id }.first

        if let groupIndex = contactViewModels.value.firstIndex(where: { $0.header.elementsEqual(String(contact.firstName.first!)) }), let index = contactViewModels.value[groupIndex].items.firstIndex(where: { $0.id == contact.id }) {
            // contactViewModels.value[groupIndex].items[index] = contact
        }

        // var value = contactViewModels.value.filter { $0.header.elementsEqual(String(contact.firstName.first!))}.first?.items.firstIndex { $0.id == contact.id }
    }

    func contactAdded(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)

        let groupedContacts = Dictionary(grouping: [contact], by: { String($0.firstName.first!) })
        let contactGroups = groupedContacts.map { ContactGroup(header: $0.0, items: $0.1) }
            .sorted { $0.header < $1.header }

        contactViewModels.accept(contactViewModels.value + contactGroups)
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
