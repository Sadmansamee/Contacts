//
//  Extension+RX.swift
//  Contacts
//
//  Created by sadman samee on 10/15/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        contentOffset.y + frame.size.height + edgeOffset > contentSize.height
    }

    func isAtBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        contentOffset.y + frame.size.height + edgeOffset == contentSize.height
    }
}

extension BehaviorRelay where Element: RangeReplaceableCollection {
    func add(element: Element.Element) {
        var array = value
        array.append(element)
        accept(array)
    }
}
