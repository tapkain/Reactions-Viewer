//
//  ReactionGridViewController.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public class ReactionGridViewController: UIViewController {
    public var viewOutput: ReactionGridPresenter?
    
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
    
    @IBOutlet private var _gridView: UICollectionView!
}

extension ReactionGridViewController: ReactionGridViewInput {
    public var gridView: UICollectionView {
        return _gridView
    }
    
    public func setTabBarItem(_ tabBarItem: UITabBarItem, navigationBarTitle: String) {
        self.navigationController?.tabBarItem = tabBarItem
        self.navigationItem.title = navigationBarTitle
    }
}

extension ReactionGridViewController: NibRepresentable {}
