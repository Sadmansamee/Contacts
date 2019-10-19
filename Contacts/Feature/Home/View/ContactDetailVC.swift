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

    @IBOutlet weak var headerCell: UITableViewCell!
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var imageViewFavourite: UIImageView!
    @IBOutlet weak var labelMobile: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    private var loadingView: UIActivityIndicatorView!

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
        
        viewModel.isLoading
                   .map { [weak self] isLoading in
                       if isLoading {
                           self?.loadingView.startAnimating()
                       } else {
                           self?.loadingView.stopAnimating()
                       }
                   }
                   .subscribe()
                   .disposed(by: disposeBag)
        
        viewModel.contactViewModel
                       .map { [weak self] in
                            self?.setContactDetailUI(contactViewModel: $0)
                       }.subscribe()
                       .disposed(by: disposeBag)
        
    }

    private func setUI() {
        headerCell.layerGradient(startColor: .white, endColor: .litePaste)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(actionEdit(_:)))
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

    
    private func setContactDetailUI(contactViewModel: ContactViewModel){
        let url = URL(string: contactViewModel.profilePicVM)
        imageViewProfile.kf.setImage(with: url,placeholder: #imageLiteral(resourceName: "placeholder_photo"))
        labelName.text = contactViewModel.name
        
        labelEmail.text = contactViewModel.emailVM
        labelMobile.text = contactViewModel.phoneNumberVM
        
        if(contactViewModel.isFavorite){
            imageViewFavourite.image = #imageLiteral(resourceName: "favourite_button_selected")
        }else{
            imageViewFavourite.image = #imageLiteral(resourceName: "favourite_button")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @IBAction func actionDelete(_ sender: Any) {
        
    }
    
    @IBAction func actionEdit(_ sender: Any) {
        
    }
    
    
//    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0
//    }
}
