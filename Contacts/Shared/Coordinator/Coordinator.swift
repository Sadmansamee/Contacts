//
//  Coordinator.swift
//  Contacts
//
//  Created by sadman samee on 10/9/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation

protocol Coordinator: AnyObject {
    func start()
}

protocol CoordinatorFinishOutput {
    var finishFlow: (() -> Void)? { get set }
}
