//
//  ContactEditCreateVC.swift
//  Contacts
//
//  Created by sadman samee on 10/19/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

protocol ContactEditCreateVCProtocol: AnyObject {
    var onBack: (() -> Void)? { get set }
    var onSuccess: ((ContactViewModel) -> Void)? { get set }
}

class ContactEditCreateVC: UITableViewController, HomeStoryboardLoadable, ContactEditCreateVCProtocol {
    // MARK: - ContactEditCreateVCProtocol

    var onBack: (() -> Void)?
    var onSuccess: ((ContactViewModel) -> Void)?

    private var disposeBag = DisposeBag()

    var viewModel: ContactEditCreateViewModel!

    @IBOutlet var headerCell: UITableViewCell!

    @IBOutlet var btnDone: UIButton!
    @IBOutlet var btnCancel: UIButton!
    @IBOutlet var imageViewProfile: UIImageView!

    @IBOutlet var textFieldFirstName: UITextField!
    @IBOutlet var textFieldLastName: UITextField!
    @IBOutlet var textFieldMobile: UITextField!

    @IBOutlet var textFieldEmail: UITextField!
    private var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        viewModelCallbacks()
    }

    @IBAction func actionDone(_: Any) {}

    @IBAction func actionCancel(_: Any) {
        onBack?()
    }

    // MARK: - Private functions

    func viewModelCallbacks() {
        viewModel.onAlertMessage
            .map { [weak self] in
                self?.showAlert(title: $0.title ?? "", message: $0.message ?? "")
            }.subscribe()
            .disposed(by: disposeBag)

        viewModel.onLoading
            .map { [weak self] isLoading in
                if isLoading {
                    self?.loadingView.startAnimating()
                } else {
                    self?.loadingView.stopAnimating()
                }
            }
            .subscribe()
            .disposed(by: disposeBag)

        viewModel.onSuccess
            .map { [weak self] in
                // self?.setContactDetailUI(contactViewModel: $0)
                self?.onSuccess?($0.0)
                self?.onBack?()
            }.subscribe()
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        textFieldFirstName.rx.text.orEmpty
            .bind(to: viewModel.firstName)
            .disposed(by: disposeBag)

        textFieldLastName.rx.text.orEmpty
            .bind(to: viewModel.lastName)
            .disposed(by: disposeBag)

        textFieldMobile.rx.text.orEmpty
            .bind(to: viewModel.phoneNumber)
            .disposed(by: disposeBag)

        textFieldEmail.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: disposeBag)

        viewModel.isValidAll
            .bind(to: btnDone.rx.isEnabled)
            .disposed(by: disposeBag)

        btnDone.rx.tap.asObservable()
            .bind(to: viewModel.doneButtonTapped)
            .disposed(by: disposeBag)
    }

    private func setUI() {
        headerCell.layerGradient(startColor: .white, endColor: .litePaste)
        setLoadingView()
        imageViewProfile.makeCircular()
    }

    private func setLoadingView() {
        //                if #available(iOS 13.0, *) {
        //                    loadingView = UIActivityIndicatorView(style: .large)
        //                } else {
        //                    // Fallback on earlier versions
        //                    loadingView = UIActivityIndicatorView(style: .gray)
        //                }

        loadingView = UIActivityIndicatorView(style: .gray)
        loadingView.startAnimating()
        loadingView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: view.bounds.width, height: CGFloat(70))
        loadingView.center = view.center
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
}
