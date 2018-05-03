//
//  ReactionFeedViewController.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

extension ReactionFeedViewController: ReactionFeedViewInput {
    public var reactionsTableView: UITableView {
        return _reactionsTableView
    }
    public var activityIndicator: UIActivityIndicatorView {
        return _activityIndicator
    }
    
    public func setTabBarItem(_ tabBarItem: UITabBarItem, navigationBarTitle: String) {
        self.navigationController?.tabBarItem = tabBarItem
        self.navigationItem.title = navigationBarTitle
    }
}

public final class ReactionFeedViewController: UIViewController {
    public var viewOutput: ReactionFeedViewOutput?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        viewOutput?.handleViewDidLoad()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewOutput?.handleViewDidAppear()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewOutput?.handleViewDidDisappear()
    }
    
    @IBOutlet private var _reactionsTableView: UITableView!
    @IBOutlet var _activityIndicator: UIActivityIndicatorView!
}

extension ReactionFeedViewController: NibRepresentable {}
