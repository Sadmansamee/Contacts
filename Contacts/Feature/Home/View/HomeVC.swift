//
//  HomeVC.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Kingfisher
import RxCocoa
import RxSwift
import Swinject
import UIKit

class HomeVC: UIViewController, HomeStoryboardLoadable {
    var onContactSelected: ((ContactViewModel) -> Void)?

    @IBOutlet var tableView: UITableView!
    var viewModel: HomeVM!
    private var disposeBag = DisposeBag()


    @IBOutlet var loadingView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLoadingView()
        setUpTableView()
        bindViewModel()
        setTableViewModel()
    }

    // MARK: - Private functions

    private func setUI() {

        title = "SURVEYS"

        let attributes = [NSAttributedString.Key.font: UIFont(name: "Avenir", size: 20)!]
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }

    private func bindViewModel() {
        viewModel.fetchContactss()

        // show initial loading view
        viewModel.onShowingLoading
                .map { [weak self] isLoading in
                    if isLoading {
                        self?.loadingView.startAnimating()
                    } else {
                        self?.loadingView.stopAnimating()
                    }
                }
                .subscribe()
                .disposed(by: disposeBag)

        //to show if there are any alert
        viewModel.onShowAlert
                .map { [weak self] in
                    self?.showAlert(title: $0.title ?? "", message: $0.message ?? "")
                }
                .subscribe()
                .disposed(by: disposeBag)


    }

    private func setLoadingView() {
        
        //        if #available(iOS 13.0, *) {
        //            loadingView = UIActivityIndicatorView(style: .large)
        //        } else {
        //            // Fallback on earlier versions
        //            loadingView = UIActivityIndicatorView(style: .gray)
        //        }

        loadingView = UIActivityIndicatorView(style: .white)
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

// MARK: - TableView

extension HomeVC {
    // MARK: - View Model TableView

    private func setTableViewModel() {
        // setting delegate
        tableView.rx.setDelegate(self)
                .disposed(by: disposeBag)

        // when cell is selected
        tableView.rx
                .modelSelected((ContactViewModel, Bool).self)
                .subscribe(
                        onNext: { [weak self] vm in
                            if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                                self?.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                                //self?.onContactSelected?(self.currentContacts)

                            }
                        }
                )
                .disposed(by: disposeBag)

        viewModel.cells.bind(to: tableView.rx.items) { tableView, _, element in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.id) as? ContactTableViewCell else {
                return UITableViewCell()
            }
            cell.viewModel = element
            return cell
        }.disposed(by: disposeBag)

        //For pagination
//        tableView.rx.contentOffset
//            .flatMap { [weak self] edge in
//                self?.tableView.isNearBottomEdge(edgeOffset: 250.0) ?? false
//                    ? Observable.just(())
//                    : Observable.empty()
//        }.asObservable()
//            //.take(1)
//            //.debounce(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
//            .subscribe { [weak self] edge in
//                print("edge \(edge.element)")
//                self?.viewModel.fetchContactss(isLoadingMore: true)
//        }.disposed(by: disposeBag)

    }

    private func setUpTableView() {
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(ContactTableViewCell.nib, forCellReuseIdentifier: ContactTableViewCell.id)
    }
}

extension HomeVC: UITableViewDelegate {
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        70
    }
}
