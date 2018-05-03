//
//  InputValidationService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public protocol InputValidationService {
    func isEmailValid(_ email: String) -> Bool
    func isPasswordValid(_ password: String) -> Bool
}
