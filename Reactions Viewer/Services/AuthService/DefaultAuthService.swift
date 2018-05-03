//
//  DefaultAuthService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public final class DefaultAuthService: AuthService {
    public func signIn(withLogin login: String,
                       password: String,
                       completion: @escaping SignInCompletion) {
        AuthAPI.signIn(requestAuthSignIn: RequestAuthSignIn(username: login, password: password)) { (response, error) in
            guard let idToken = response?.idToken, error == nil else {
                completion(false, error)
                return
            }
            
            SwaggerClientAPI.customHeaders["Authorization"] = "Bearer " + idToken
            completion(true, nil)
        }
    }
}
