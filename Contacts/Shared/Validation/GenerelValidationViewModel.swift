//
//  GenerelValidation.swift
//  Contacts
//
//  Created by sadman samee on 10/19/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class GenerelValidationViewModel: ValidationViewModel {
    var data = BehaviorRelay<String>(value: "")

    var errorValue = BehaviorRelay<String?>(value: "")

    var errorMessage: String = ""

    func validate(minLength minLenth: Int = 4) -> Bool {
        guard validateLength(text: data.value, minLenth: minLenth) else {
            errorValue.accept(errorMessage)
            return false
        }

        errorValue.accept("")
        return true
    }

    func validateLength(text: String, minLenth: Int = 4) -> Bool {
        return text.count >= minLenth
    }
}
