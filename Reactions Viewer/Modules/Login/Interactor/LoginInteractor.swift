//
//  LoginInteractor.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public struct LoginState {
    public let isAuthenticated: Bool
    public let isPendingResponse: Bool
    public let isInputValidated: Bool
    public let error: Error?
    
    public init(isAuthenticated: Bool = false,
         isPendingResponse: Bool = false,
         isInputValidated: Bool = false,
         error: Error? = nil) {
        self.isAuthenticated = isAuthenticated
        self.isPendingResponse = isPendingResponse
        self.isInputValidated = isInputValidated
        self.error = error
    }
}

public final class LoginInteractor {
    public weak var presenter: LoginPresenter?
    private var _authService: AuthService
    private var _validationService: InputValidationService
    
    public init(authService: AuthService,
                validationService: InputValidationService) {
        _authService = authService
        _validationService = validationService
    }
    
    public func validateInput(withEmail email: String,
                              password: String) {
        let isInputValidated = _validationService.isEmailValid(email)
                                && _validationService.isPasswordValid(password)
        let validationState = LoginState(isInputValidated: isInputValidated)
        presenter?.update(withState: validationState)
    }
    
    public func signIn(withEmail email: String,
                       password: String) {
        presenter?.update(withState: LoginState(isPendingResponse: true))
        
        _authService.signIn(withLogin: email, password: password) { (success, error) in
            DispatchQueue.main.async {
                self.presenter?.update(withState: LoginState(isAuthenticated: success && error == nil,
                                                             error: error))
            }
        }
    }
    
    public func setup() {
        presenter?.update(withState: LoginState())
    }
}
