//
//  LoginPresenter.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public final class LoginPresenter {
    private var _interactor: LoginInteractor
    private weak var _view: LoginViewController?
    
    public init(interactor: LoginInteractor,
                view: LoginViewController) {
        _interactor = interactor
        _view = view
    }
    
    public func handleSignInEvent() {
        guard let email = _view?.email,
            let password = _view?.password else {
                return
        }
        
        _interactor.signIn(withEmail: email, password: password)
    }
    
    public func handleViewDidLoad() {
        _interactor.setup()
        #if DEBUG
        _view?.set(email: "iod@gifto12.com",
                   password: "qqqqqq1Q")
        handleInputChangeEvent()
        #endif
    }
    
    public func handleInputChangeEvent() {
        guard let email = _view?.email,
            let password = _view?.password else {
                return
        }
        
        _interactor.validateInput(withEmail: email, password: password)
    }
    
    public func update(withState state: LoginState) {
        _view?.setControlsHidden(state.isAuthenticated || state.isPendingResponse)
        _view?.setErrorHidden(state.error == nil,
                              message: state.error.debugDescription)
        _view?.setSignInButtonActive(state.isInputValidated)
        _view?.setActivityIndicatorHidden(!state.isPendingResponse)
        if state.error != nil {
            _view?.resetPassword()
        }
        
        if state.isAuthenticated {
            Navigator.navigate(to: .root)
        }
    }
}
