//
//  AppDelegate+Setup.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
import Swinject

extension AppDelegate {
    /**
     Set up the dependency graph in the DI container
     */
    internal func setupDependencies() {
        // MARK: - Providers

        container.register(MoyaProvider<ContactService>.self, factory: { _ in
            MoyaProvider<ContactService>(plugins: [NetworkLoggerPlugin(verbose: true,
                                                                       responseDataFormatter: JSONResponseDataFormatter)])
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
    }
}
