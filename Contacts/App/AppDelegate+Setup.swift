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
            MoyaProvider<ContactService>()
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Model

        container.register(ContactsVM.self, factory: { container in
            ContactsVM(homeProvider: container.resolve(MoyaProvider<ContactService>.self)!)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Controllers

        container.storyboardInitCompleted(ContactsVC.self) { r, c in
            c.viewModel = r.resolve(ContactsVM.self)
        }

        container.storyboardInitCompleted(ContactDetailVC.self) { _, _ in
        }
    }
}
