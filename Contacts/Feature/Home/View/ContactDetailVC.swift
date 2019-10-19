//
//  ContactsDetailVC.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift
import UIKit

protocol ContactDetailVCProtocol: AnyObject {
    var onBack: (() -> Void)? { get set }
}

class ContactDetailVC: UITableViewController, HomeStoryboardLoadable, ContactDetailVCProtocol {
    // MARK: - Properties

    var viewModel: ContactsDetailVM!
    var onBack: (() -> Void)?
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        bindViewModel()
    }

    // MARK: - Private functions

    private func bindViewModel() {
        viewModel.alertMessage
            .map { [weak self] in
                self?.showAlert(title: $0.title ?? "", message: $0.message ?? "")
            }.subscribe()
            .disposed(by: disposeBag)
    }

    private func setUI() {}

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
