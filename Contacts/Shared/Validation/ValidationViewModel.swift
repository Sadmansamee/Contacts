//
//  ValidationViewModel.swift
//  Contacts
//
//  Created by sadman samee on 10/19/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

protocol ValidationViewModel {
    var errorMessage: String { get }

    // Observables
    var data: BehaviorRelay<String> { get set }
    var errorValue: BehaviorRelay<String?> { get }

    // Validation
    func validate(minLength: Int) -> Bool
}
