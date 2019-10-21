//
//  Animator.swift
//  Contacts
//
//  Created by sadman samee on 10/21/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

import UIKit

final class Animator {
    private var hasAnimatedAllCells = false
    private let animation: Animation

    init(animation: @escaping Animation) {
        self.animation = animation
    }

    func animate(cell: UITableViewCell, at indexPath: IndexPath, in tableView: UITableView) {
        guard !hasAnimatedAllCells else {
            return
        }

        animation(cell, indexPath, tableView)

        hasAnimatedAllCells = tableView.isLastVisibleCell(at: indexPath)
    }
}
