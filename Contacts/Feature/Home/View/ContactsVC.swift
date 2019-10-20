//
//  HomeVC.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxDataSources
import RxSwift
import Swinject
import UIKit

protocol ContactsVCProtocol: AnyObject {
    var onAddContact: (() -> Void)? { get set }
    var onContactSelected: ((ContactViewModel) -> Void)? { get set }
}

class ContactsVC: UIViewController, HomeStoryboardLoadable, ContactsVCProtocol {
    // MARK: - ContactsVCProtocol

    var onAddContact: (() -> Void)?
    var onContactSelected: ((ContactViewModel) -> Void)?

    @IBOutlet var tableView: UITableView!
    var viewModel: ContactsViewModel!
    private var disposeBag = DisposeBag()

    var loadingView: UIActivityIndicatorView!
    var dataSource: RxTableViewSectionedReloadDataSource<ContactGroup>?

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ContactsVC.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .paste

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLoadingView()
        setUpTableView()
        bindViewModel()
        viewModelCallbacks()

        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateContact(_:)), name: .didContactUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onAddContact(_:)), name: .didContactAdded, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onDeleteContact(_:)), name: .didContactDeleted, object: nil)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Private functions

    @objc private func handleRefresh(_ refreshControl: UIRefreshControl) {
        viewModel.fetchContacts()
        refreshControl.endRefreshing()
    }

    private func setUI() {
        title = "Contact"

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "add.png")
            .withRenderingMode(.alwaysOriginal), style: .plain,
                                                            target: self,
                                                            action: #selector(actionAddContact(_:)))
        tableView.addSubview(refreshControl)
    }

    @objc func onUpdateContact(_ notification: Notification) {
        if let dictionary = notification.userInfo as? [String: Any] {
            viewModel.contactUpdated(dictionary: dictionary)
        }
    }

    @objc func onAddContact(_ notification: Notification) {
        if let dictionary = notification.userInfo as? [String: Any] {
            viewModel.contactAdded(dictionary: dictionary)
        }
    }

    @objc func onDeleteContact(_ notification: Notification) {
          if let dictionary = notification.userInfo as? [String: Any] {
              viewModel.contactDeleted(dictionary: dictionary)
          }
      }

    private func viewModelCallbacks() {
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
        viewModel.fetchContacts()
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

    @objc func actionAddContact(_: Any) {
        onAddContact?()
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        present(alert, animated: true)
    }
}

// MARK: - TableView

extension ContactsVC {
    // MARK: - TableView

    private func setUpTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ContactTableViewCell.nib, forCellReuseIdentifier: ContactTableViewCell.id)

        let dataSource = RxTableViewSectionedReloadDataSource<ContactGroup>(
            configureCell: { _, tableView, _, item in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.id)
                    as? ContactTableViewCell else {
                    return UITableViewCell()
                }
                cell.viewModel = item
                return cell
            },
            titleForHeaderInSection: { dataSource, index in
                dataSource.sectionModels[index].header
            }, sectionIndexTitles: { dataSource in
                dataSource.sectionModels.map { $0.header }
            }, sectionForSectionIndexTitle: { _, _, index in
                index
            }
        )

        self.dataSource = dataSource
        // when cell is selected
        tableView.rx
            .modelSelected(Contact.self)
            .subscribe(
                onNext: { [weak self] item in
                    if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                        self?.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                        self?.onContactSelected?(item)
                    }
                }
            )
            .disposed(by: disposeBag)

        viewModel.onContactViewModels
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

//                viewModel.contactViewModels.bind(to: tableView.rx.items) { tableView, _, element in
//                    guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.id) as? ContactTableViewCell else {
//                        return UITableViewCell()
//                    }
//                    cell.viewModel = element
//                    return cell
//                }.disposed(by: disposeBag)

        // setting delegate
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

extension ContactsVC: UITableViewDelegate {
    func tableView(_: UITableView, heightForHeaderInSection _: Int) -> CGFloat {
        return 28
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        65
    }
}
