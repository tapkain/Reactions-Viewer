//
//  DefaultInputValidationService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation
import SwiftCop

public final class DefaultInputValidationService: InputValidationService {
    private let kPasswordMinLength = 8
    
    public func isEmailValid(_ email: String) -> Bool {
        return Trial.email.trial()(email)
    }
    
    public func isPasswordValid(_ password: String) -> Bool {
        let _password = password as NSString
        return password.count >= kPasswordMinLength
            && _password.rangeOfCharacter(from: .decimalDigits).location != NSNotFound
            && _password.rangeOfCharacter(from: .uppercaseLetters).location != NSNotFound
    }
}
