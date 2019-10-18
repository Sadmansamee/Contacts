//
//  Extension+View.swift
//  Contacts
//
//  Created by sadman samee on 10/15/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func roundedCorner(radius: CGFloat) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }

    func makeCircular() {
        layer.cornerRadius = min(frame.size.height, frame.size.width) / 2.0
        clipsToBounds = true
    }
}
