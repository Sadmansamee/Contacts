//
//  EmailIdViewModel.swift
//  Contacts
//
//  Created by sadman samee on 10/19/19.
//  Copyright © 2019 Sadman Samee. All rights reserved.
//

import Foundation
import RxRelay
import RxSwift

class EmailValidationViewModel: ValidationViewModel {
    var data = BehaviorRelay<String>(value: "")

    var errorValue = BehaviorRelay<String?>(value: "")

    var errorMessage: String = "Please enter a valid Email Id"

    func validate(minLength minLenth: Int = 6) -> Bool {
        guard validatePattern(text: data.value, minLenth: minLenth) else {
            errorValue.accept(errorMessage)
            return false
        }

        errorValue.accept("")
        return true
    }

    func validatePattern(text: String, minLenth: Int) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: text) && text.count >= minLenth
    }
}
