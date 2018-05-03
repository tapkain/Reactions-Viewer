//
//  AuthService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public protocol AuthService {
    typealias SignInCompletion = ((Bool, Error?) -> Void)
    
    func signIn(withLogin login: String,
                password: String,
                completion: @escaping SignInCompletion)
}
