//
//  SurveryTableViewCell.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    @IBOutlet var imageViewProfile: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var imageViewFavorite: UIImageView!
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
        if let viewModel = viewModel {
            labelName.text = viewModel.name
            imageViewFavorite.isHidden = !viewModel.isFavorite

            let url = URL(string: viewModel.profilePicVM)
            imageViewProfile.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder_photo"))
        }
    }
}
