//
//  ViewControllerLeakTests+Setup.swift
//  ContactsTests
//
//  Created by sadman samee on 10/10/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
@testable import Contacts
import Swinject

extension ViewControllerTest {
    /**
     Set up the depedency graph in the DI container
     */
    func setupDependencies() -> Container {
        let container = Container()

     
        container.register(MoyaProvider<ContactService>.self, factory: { _ in
            MoyaProvider<ContactService>()
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Model

        container.register(ContactsViewModel.self, factory: { container in
            ContactsViewModel(contactProvider: container.resolve(MoyaProvider<ContactService>.self)!)
        }).inObjectScope(ObjectScope.container)

        container.register(ContactEditCreateViewModel.self, factory: { container in
            ContactEditCreateViewModel(contactProvider: container.resolve(MoyaProvider<ContactService>.self)!)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Controllers

        container.storyboardInitCompleted(ContactsVC.self) { resolver, controller in
            controller.viewModel = resolver.resolve(ContactsViewModel.self)
        }

        container.storyboardInitCompleted(ContactDetailVC.self) { _, _ in
        }

        container.storyboardInitCompleted(ContactEditCreateVC.self) { resolver, controller in
            controller.viewModel = resolver.resolve(ContactEditCreateViewModel.self)
        }

        return container
    }
}
