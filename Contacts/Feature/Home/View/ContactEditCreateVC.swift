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
}

class ContactEditCreateVC: UITableViewController, HomeStoryboardLoadable, ContactEditCreateVCProtocol {
    // MARK: - ContactEditCreateVCProtocol

    var onBack: (() -> Void)?

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

        setUI()
        bindViewModel()
        viewModelCallbacks()
    }

    @IBAction func actionCancel(_: Any) {
        onBack?()
    }

    // MARK: - Private functions

    private func setUI() {

         btnDone.setTitleColor(.darkGray, for: .disabled)
         btnDone.setTitleColor(.paste, for: .normal)

         btnDone.isEnabled = false
         headerCell.layerGradient(startColor: .white, endColor: .litePaste)
         setLoadingView()
         imageViewProfile.makeCircular()
        tableView.keyboardDismissMode = .interactive

         textFieldFirstName.becomeFirstResponder()
     }

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

        viewModel.onCreateSuccess
            .map { [weak self] in
                if $0.1 {
                    NotificationCenter.default.post(name: .didContactAdded, object: nil, userInfo: $0.0.contactVM.toDictionary())
                    self?.onBack?()
                }
        }.subscribe()
            .disposed(by: disposeBag)

        viewModel.onEditSuccess
            .map { [weak self] in
                if $0.1 {
                    NotificationCenter.default.post(name: .didContactUpdated, object: nil, userInfo: $0.0.contactVM.toDictionary())
                    self?.onBack?()
                }
        }.subscribe()
            .disposed(by: disposeBag)

        viewModel.onImageUrl
            .map { [weak self] url in

                self?.imageViewProfile.kf.setImage(with: URL(string: url), placeholder: #imageLiteral(resourceName: "placeholder_photo"))
        }.subscribe()
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        bind(textField: textFieldFirstName, to: viewModel.firstName)
        bind(textField: textFieldLastName, to: viewModel.lastName)
        bind(textField: textFieldMobile, to: viewModel.phoneNumber)
        bind(textField: textFieldEmail, to: viewModel.email)

        viewModel.isValidAll
            .bind(to: btnDone.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isValidAll
            .map { [weak self] in
                if $0 {
                    self?.scrollToTop()
                    self?.btnDone.shake(duration: 1)
                }
        }.subscribe()
            .disposed(by: disposeBag)

        btnDone.rx.tap.asObservable()
            .bind(to: viewModel.doneButtonTapped)
            .disposed(by: disposeBag)
    }

    private func bind(textField: UITextField, to behaviorRelay: BehaviorRelay<String>) {
        behaviorRelay.asObservable()
            .bind(to: textField.rx.text)
            .disposed(by: disposeBag)
        textField.rx.text.orEmpty
            .bind(to: behaviorRelay)
            .disposed(by: disposeBag)
    }

    func scrollToTop() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
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
