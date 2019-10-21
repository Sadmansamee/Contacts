//
//  Extension+TableView.swift
//  Contacts
//
//  Created by sadman samee on 10/21/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func isLastVisibleCell(at indexPath: IndexPath) -> Bool {
        guard let lastIndexPath = indexPathsForVisibleRows?.last else {
            return false
        }

        return lastIndexPath == indexPath
    }
}
