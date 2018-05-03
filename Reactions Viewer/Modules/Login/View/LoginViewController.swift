//
//  LoginViewController.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

extension LoginViewController {
    public var email: String {
        return _loginInput.text ?? ""
    }
    
    public var password: String {
        return _passwordInput.text ?? ""
    }
    
    public func setActivityIndicatorHidden(_ isHidden: Bool) {
        _activityIndicator.isHidden = isHidden
        if isHidden {
            _activityIndicator.stopAnimating()
        } else {
            _activityIndicator.startAnimating()
        }
    }
    
    public func setControlsHidden(_ isHidden: Bool) {
        _loginInput.isHidden = isHidden
        _passwordInput.isHidden = isHidden
        _signInButton.isHidden = isHidden
    }
    
    public func setSignInButtonActive(_ isActive: Bool) {
        _signInButton.isUserInteractionEnabled = isActive
        _signInButton.backgroundColor = isActive ? .blue : .gray
    }
    
    public func setErrorHidden(_ isHidden: Bool, message: String?) {
        _errorLabel.isHidden = isHidden
        _errorLabel.text = message
    }
    
    public func resetPassword() {
        _passwordInput.text = ""
    }
    
    #if DEBUG
    public func set(email: String, password: String) {
        _passwordInput.text = password
        _loginInput.text = email
    }
    #endif
}

public final class LoginViewController: UIViewController {
    public var presenter: LoginPresenter?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        presenter?.handleViewDidLoad()
        _loginInput.delegate = self
        _passwordInput.delegate = self
    }
    
    @IBAction private func _signIn(_ sender: Any) {
        presenter?.handleSignInEvent()
    }
    
    private let kKeyboardTopOffset: CGFloat = 10.0
    
    @IBOutlet private var _loginInput: UITextField!
    @IBOutlet private var _passwordInput: UITextField!
    @IBOutlet private var _signInButton: UIButton!
    @IBOutlet private var _activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var _errorLabel: UILabel!
    @IBOutlet private var _bottomOffsetConstraint: NSLayoutConstraint!
    
    
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addKeyboardObserver()
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardObserver()
    }
}

extension LoginViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField,
                          shouldChangeCharactersIn range: NSRange,
                          replacementString string: String) -> Bool {
        textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        presenter?.handleInputChangeEvent()
        return false
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        presenter?.handleInputChangeEvent()
    }
}

//MARK: Keyboard handling
extension LoginViewController {
    fileprivate func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(_keyboardWillShown(notification:)),
                                               name: .UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector:#selector(_keyboardWillHide(notification:)),
                                               name: .UIKeyboardWillHide,
                                               object: nil)
    }
    
    fileprivate func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillShow,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: .UIKeyboardWillHide,
                                                  object: nil)
    }
    
    @objc fileprivate func _keyboardWillShown(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        let params = _parseKeyboardInfo(info)
        let keyboardFrame = view.convert(params.frame, to: nil)
        
        _animateKeyboardTransition(height: keyboardFrame.height + kKeyboardTopOffset,
                                   duration: params.duration,
                                   curve: params.curve)
    }
    
    @objc fileprivate func _keyboardWillHide(notification: NSNotification) {
        guard let info = notification.userInfo else {
            return
        }
        let params = _parseKeyboardInfo(info)
        
        _animateKeyboardTransition(height: 0,
                                   duration: params.duration,
                                   curve: params.curve)
    }
    
    private func _animateKeyboardTransition(height: CGFloat,
                                            duration: Double,
                                            curve: UIViewAnimationOptions) {
        self.view.layoutIfNeeded()
        _bottomOffsetConstraint?.constant = height
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: curve,
                       animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func _parseKeyboardInfo(_ info: [AnyHashable : Any]) -> (frame: CGRect, duration: Double, curve: UIViewAnimationOptions) {
        let frame = (info[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue ?? CGRect.zero
        let duration = (info[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.0
        let curveRaw = (info[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue ?? 0
        let curve = UIViewAnimationOptions.init(rawValue: UInt(curveRaw))
        return (frame, duration, curve)
    }
}

extension LoginViewController: NibRepresentable {}
