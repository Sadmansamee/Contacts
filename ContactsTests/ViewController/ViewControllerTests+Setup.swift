//
//  ViewControllerLeakTests+Setup.swift
//  ContactsTests
//
//  Created by sadman samee on 10/10/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

@testable import Contacts
import Foundation
import Moya
import SwiftyJSON
import Swinject

extension ViewControllerTest {
    /**
     Set up the depedency graph in the DI container
     */
    func setupDependencies() -> Container {
        let container = Container()

        container.register(MoyaProvider<ContactService>.self, factory: { _ in
            MoyaProvider<ContactService>(stubClosure: MoyaProvider.immediatelyStub)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Model

        container.register(ContactsViewModel.self, factory: { container in
            ContactsViewModel(contactProvider: container.resolve(MoyaProvider<ContactService>.self)!)
        }).inObjectScope(ObjectScope.container)

        container.register(ContactEditCreateViewModel.self, factory: { container in

            let path = Bundle.main.path(forResource: MockJson.contact.rawValue, ofType: "json")!
            let url = URL(fileURLWithPath: path)
            let json = try? JSON(data: Data(contentsOf: url))
            let contact = Contact(fromJson: json)

            return ContactEditCreateViewModel(contactProvider: container.resolve(MoyaProvider<ContactService>.self)!, viewModel: contact)
        }).inObjectScope(ObjectScope.container)

        container.register(ContactDetailViewModel.self, factory: { container in

            let path = Bundle.main.path(forResource: MockJson.contact.rawValue, ofType: "json")!
            let url = URL(fileURLWithPath: path)
            let json = try? JSON(data: Data(contentsOf: url))
            let contact = Contact(fromJson: json)

            return ContactDetailViewModel(contactProvider: container.resolve(MoyaProvider<ContactService>.self)!, viewModel: contact)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Controllers

        container.storyboardInitCompleted(ContactsVC.self) { resolver, controller in
            controller.viewModel = resolver.resolve(ContactsViewModel.self)
        }

        container.storyboardInitCompleted(ContactDetailVC.self) { resolver, controller in
            controller.viewModel = resolver.resolve(ContactDetailViewModel.self)
        }

        container.storyboardInitCompleted(ContactEditCreateVC.self) { resolver, controller in
            controller.viewModel = resolver.resolve(ContactEditCreateViewModel.self)
        }

        return container
    }
}
