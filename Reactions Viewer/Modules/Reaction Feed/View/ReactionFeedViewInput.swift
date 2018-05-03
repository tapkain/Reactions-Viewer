//
//  ReactionFeedViewInput.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public protocol ReactionFeedViewInput: class {
    var reactionsTableView: UITableView { get }
    
    var activityIndicator: UIActivityIndicatorView { get }
    func setTabBarItem(_ tabBarItem: UITabBarItem, navigationBarTitle: String)
}
