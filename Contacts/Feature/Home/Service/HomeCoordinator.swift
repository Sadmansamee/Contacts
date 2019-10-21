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
        let viewController = container.resolveViewController(ContactsVC.self)
        viewController.onContactSelected = { viewModel in
            self.showContactsDetailVC(viewModel:
                ContactDetailViewModel(contactProvider: self.container.resolve(MoyaProvider<ContactService>.self)!,
                                       viewModel: viewModel))
        }
        viewController.onAddContact = { [unowned self] in
            self.showToAddContactEditCreateVC()
        }
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showContactsDetailVC(viewModel: ContactDetailViewModel) {
        let viewController = container.resolveViewController(ContactDetailVC.self)
        viewController.onBack = { [unowned self] in
            self.navigationController.popViewController(animated: true)
        }

        viewController.onEditContact = { contactViewModel in
            self.showToEditContactEditCreateVC(viewModel:
                ContactEditCreateViewModel(contactProvider: self.container.resolve(MoyaProvider<ContactService>.self)!,
                                           viewModel: contactViewModel))
        }
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }

    private func showToEditContactEditCreateVC(viewModel: ContactEditCreateViewModel) {
        let viewController = container.resolveViewController(ContactEditCreateVC.self)
        viewController.onBack = { [unowned self] in
            self.navigationController.dismiss(animated: true, completion: nil)
        }

        viewController.viewModel = viewModel
        navigationController.present(viewController, animated: true, completion: nil)
    }

    private func showToAddContactEditCreateVC() {
        let viewController = container.resolveViewController(ContactEditCreateVC.self)
        viewController.onBack = { [unowned self] in
            self.navigationController.dismiss(animated: true, completion: nil)
        }

        navigationController.present(viewController, animated: true, completion: nil)
    }
}
