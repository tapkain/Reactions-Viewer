//
//  ReactionGridView.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public protocol ReactionGridViewInput: class {
    var gridView: UICollectionView { get }
    func setTabBarItem(_ tabBarItem: UITabBarItem, navigationBarTitle: String)
}
