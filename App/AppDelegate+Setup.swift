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

        let tokenService = TokenService()

        let tokenClosure: () -> String = {
            tokenService.getAcessToken()
        }

        container.register(MoyaProvider<HomeService>.self, factory: { _ in
            MoyaProvider<HomeService>(plugins: [AccessTokenPlugin(tokenClosure: tokenClosure)])
        }).inObjectScope(ObjectScope.container)

        // MARK: - View Model

        container.register(HomeVM.self, factory: { container in
            HomeVM(homeProvider: container.resolve(MoyaProvider<HomeService>.self)!)
        }).inObjectScope(ObjectScope.container)

       
        // MARK: - View Controllers

       
        container.storyboardInitCompleted(HomeVC.self) { r, c in
            c.viewModel = r.resolve(HomeVM.self)
        }

        container.storyboardInitCompleted(ContactDetailVC.self) { _, _ in
        }
    }
}
