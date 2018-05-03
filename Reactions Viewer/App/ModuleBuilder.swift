//
//  ModuleBuilder.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public final class ModuleBuilder {
    private init() { }
    
    public static func reactionFeed() -> UIViewController {
        let view = ReactionFeedViewController(nibName: ReactionFeedViewController.nibName,
                                   bundle: nil)
        let interactor = ReactionFeedInteractor(webService: DefaultWebService(),
                                                imageService: DefaultImageService(),
                                                databaseService: DefaultDatabaseService(key: "reactionFeed"))
        let router = ReactionFeedRouter(view: view)
        let presenter = ReactionFeedPresenter(view: view,
                                              interactor: interactor,
                                              router: router)
        interactor.output = presenter
        view.viewOutput = presenter
        
        return UINavigationController(rootViewController: view)
    }
    
    public static func reactionGrid() -> UIViewController {
        let view = ReactionGridViewController(nibName: ReactionGridViewController.nibName,
                                              bundle: nil)
        let interactor = ReactionGridInteractor(imageService: DefaultImageService(),
                                                databaseService: DefaultDatabaseService(key: "reactionGrid"))
        let router = ReactionGridRouter(view: view)
        let presenter = ReactionGridPresenter(view: view,
                                              interactor: interactor,
                                              router: router)
        interactor.presenter = presenter
        view.viewOutput = presenter
        
        return UINavigationController(rootViewController: view)
    }
    
    public static func login() -> UIViewController {
        let view = LoginViewController(nibName: LoginViewController.nibName,
                                       bundle: nil)
        let interactor = LoginInteractor(authService: DefaultAuthService(),
                                         validationService: DefaultInputValidationService())
        let presenter = LoginPresenter(interactor: interactor,
                                       view: view)
        interactor.presenter = presenter
        view.presenter = presenter
        
        return view
    }
}
