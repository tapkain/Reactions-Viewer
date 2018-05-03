//
//  AppDelegate.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 4/30/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public var appDelegate: AppDelegate? {
    return UIApplication.shared.delegate as? AppDelegate
}

@UIApplicationMain
public class AppDelegate: UIResponder, UIApplicationDelegate {
    public var window: UIWindow?

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        
        Navigator.navigate(to: .login)
        return true
    }
}

