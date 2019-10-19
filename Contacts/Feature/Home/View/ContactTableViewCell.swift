//
//  SurveryTableViewCell.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet weak var imageViewProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewFavorite: UIImageView!
    var viewModel: ContactViewModel? {
        didSet {
            bindViewModel()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageViewProfile.makeCircular()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    private func bindViewModel() {
        if let vm = viewModel {
            labelName.text = vm.name
            imageViewFavorite.isHidden = !vm.isFavorite
            
            let url = URL(string: vm.profilePicVM)
            imageViewProfile.kf.setImage(with: url,placeholder: #imageLiteral(resourceName: "placeholder_photo"))
            
        }
    }
}
