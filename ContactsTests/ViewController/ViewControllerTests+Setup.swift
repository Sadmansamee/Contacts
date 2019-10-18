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

        container.register(MoyaProvider<HomeService>.self, factory: { _ in
            MoyaProvider<HomeService>()
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Model

        container.register(HomeVM.self, factory: { container in

            HomeVM(homeProvider: container.resolve(MoyaProvider<HomeService>.self)!)
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Controllers
        container.storyboardInitCompleted(HomeVC.self) { r, c in
            c.viewModel = r.resolve(HomeVM.self)
        }

        return container
    }
}
