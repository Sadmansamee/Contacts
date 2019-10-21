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

    private let operatedCell = PublishSubject<(IndexPath,OperationType)>()

    
    var onLoading: Observable<Bool> {
        isLoading.asObservable()
            .distinctUntilChanged()
    }
    
    var onOperatedCell: Observable<(IndexPath,OperationType)> {
        operatedCell.asObservable()
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

        guard let section = contactViewModels.value.firstIndex(where: { $0.header.elementsEqual(String(contact.firstName.first!)) }), let row = contactViewModels.value[section].items.firstIndex(where: { $0.id == contact.id }) else{
            return
        }
        
        //simply remove the item from list
        oldValue[section].items.remove(at: row)
        
        //remove the group if there are no contact left
        if(oldValue[section].items.isEmpty){
            oldValue.remove(at: section)
        }
        
        contactViewModels.accept(oldValue)
        operatedCell.onNext((IndexPath(row: row, section: section),.deleted))

    }

    func contactUpdated(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)

        var oldValue = contactViewModels.value

        guard let section = contactViewModels.value.firstIndex(where: { $0.header.elementsEqual(String(contact.firstName.first!)) }), let row = contactViewModels.value[section].items.firstIndex(where: { $0.id == contact.id }) else{
            return
        }
        
        oldValue[section].items[row] = contact
        contactViewModels.accept(oldValue)
        operatedCell.onNext((IndexPath(row: row, section: section),.updated))
    }

    func contactAdded(dictionary: [String: Any]) {
        let json = JSON(dictionary)
        let contact = Contact(fromJson: json)

        var oldValue = contactViewModels.value

        if let section = oldValue.firstIndex(where: { $0.header.elementsEqual(String(contact.firstName.first!)) }) {
            oldValue[section].items.append(contact)
        }else{
            //Previously this group wasnot there so creating new group and sorting alphabetically
            let contactGroup = ContactGroup(header: String(contact.firstName.first!), items: [contact])
            oldValue.append(contactGroup)
            
            oldValue = oldValue.map { ContactGroup(header: $0.header, items: $0.items) }
            .sorted { $0.header < $1.header }
        }
        
        contactViewModels.accept(oldValue)
        
        if let section = contactViewModels.value.firstIndex(where: { $0.header.elementsEqual(String(contact.firstName.first!)) }), let row = contactViewModels.value[section].items.firstIndex(where: { $0.id == contact.id }) {
                            operatedCell.onNext((IndexPath(row: row, section: section),.added))

                  }
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
