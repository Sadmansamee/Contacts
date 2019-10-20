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
    var onEditContact: ((ContactViewModel) -> Void)? { get set }
}

class ContactDetailVC: UITableViewController, HomeStoryboardLoadable, ContactDetailVCProtocol {
    // MARK: - ContactDetailVCProtocol

    var onBack: (() -> Void)?
    var onEditContact: ((ContactViewModel) -> Void)?

    // MARK: - Properties

    var viewModel: ContactDetailViewModel!
    private var disposeBag = DisposeBag()

    @IBOutlet var headerCell: UITableViewCell!
    @IBOutlet var imageViewProfile: UIImageView!
    @IBOutlet var labelName: UILabel!

    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var imageViewFavourite: UIImageView!
    @IBOutlet var labelMobile: UILabel!
    @IBOutlet var labelEmail: UILabel!

    private var loadingView: UIActivityIndicatorView!
    private var contactViewModel: ContactViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        bindViewModel()
        viewModelCallbacks()

        NotificationCenter.default.addObserver(self, selector: #selector(onUpdatedContact(_:)), name: .didContactUpdated, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private functions

    private func setUI() {
        headerCell.layerGradient(startColor: .white, endColor: .litePaste)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(actionEdit(_:)))

        setLoadingView()
        imageViewProfile.makeCircular()
    }

    private func viewModelCallbacks() {
        viewModel.onDeleteSuccess
            .map { [weak self] in
                if $0.1 {
                    NotificationCenter.default.post(name: .didContactDeleted, object: nil, userInfo: $0.0.contactVM.toDictionary())
                    self?.onBack?()
                }
            }.subscribe()
            .disposed(by: disposeBag)

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
    }

    private func bindViewModel() {

        viewModel.onContactViewModel
            .map { [weak self] result in
                self?.setContactDetailUI(contactViewModel: result)
            }.subscribe()
            .disposed(by: disposeBag)

        btnDelete.rx.tap.asObservable()
            .bind(to: viewModel.deleteButtonTapped)
            .disposed(by: disposeBag)
    }

    @objc private func onUpdatedContact(_ notification: Notification) {
        if let dictionary = notification.userInfo as? [String: Any] {
            viewModel.contactUpdated(dictionary: dictionary)
        }
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

    private func setContactDetailUI(contactViewModel: ContactViewModel) {
        self.contactViewModel = contactViewModel
        imageViewProfile.kf.setImage(with: URL(string: contactViewModel.profilePicUrl), placeholder: #imageLiteral(resourceName: "placeholder_photo"))
        labelName.text = contactViewModel.name

        labelEmail.text = contactViewModel.emailVM
        labelMobile.text = contactViewModel.phoneNumberVM

        if contactViewModel.isFavorite {
            imageViewFavourite.image = #imageLiteral(resourceName: "favourite_button_selected")
        } else {
            imageViewFavourite.image = #imageLiteral(resourceName: "favourite_button")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @IBAction func actionEdit(_: Any) {
        onEditContact?(contactViewModel)
    }
}
