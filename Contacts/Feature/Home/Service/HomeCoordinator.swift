//
//  HomeCoordinator.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import Moya
import Swinject

final class HomeCoordinator: BaseCoordinator, CoordinatorFinishOutput {
    // MARK: - CoordinatorFinishOutput

    var finishFlow: (() -> Void)?
    let container: Container

    // MARK: - Vars & Lets

    let navigationController: UINavigationController

    // MARK: - Coordinator

    override func start() {
        showHomeVC()
    }

    // MARK: - Init

    init(container: Container, navigationController: UINavigationController) {
        self.container = container
        self.navigationController = navigationController
    }

    // MARK: - Private methods

    private func showHomeVC() {
        let vc = container.resolveViewController(ContactsVC.self)
        vc.onContactSelected = { viewModel in
            self.showContactsDetailVC(viewModel: ContactsDetailVM(homeProvider: self.container.resolve(MoyaProvider<ContactService>.self)!, contactViewModel: viewModel))
        }
        navigationController.pushViewController(vc, animated: true)
    }

    private func showContactsDetailVC(viewModel: ContactsDetailVM) {
        let vc = container.resolveViewController(ContactDetailVC.self)
        vc.onBack = { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
}
