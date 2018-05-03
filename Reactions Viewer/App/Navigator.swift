//
//  Navigator.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

//TODO: implement proper URL support
public final class Navigator {
    public enum Route: String {
        case login
        case root
    }
    
    private init() {}
    
    public static func navigate(to route: Route) {
        switch route {
        case .login:
            _navigateToLogin()
        case .root:
            _navigateToRoot()
        }
    }
    
    private static func _navigateToLogin() {
        appDelegate?.window?.rootViewController = ModuleBuilder.login()
    }
    
    private static func _navigateToRoot() {
        let tbc = TabBarController(nibName: "TabBarController", bundle: nil)
        let reactionFeed = ModuleBuilder.reactionFeed()
        let reactionGrid = ModuleBuilder.reactionGrid()
        tbc.setViewControllers([reactionFeed, reactionGrid], animated: false)
        appDelegate?.window?.rootViewController = tbc
        //Trick to preload all tabs' views
        tbc.viewControllers?.forEach{
            if let nvc = $0 as? UINavigationController {
                nvc.viewControllers.forEach{ let _ = $0.view }
            } else {
                let _ = $0.view
            }
        }
    }
}
