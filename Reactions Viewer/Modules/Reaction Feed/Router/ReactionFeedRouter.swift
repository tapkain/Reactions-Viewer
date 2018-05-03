//
//  ReactionFeedRouter.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public final class ReactionFeedRouter: ReactionFeedRouterInput {
    private weak var _view: ReactionFeedViewInput?
    
    public init(view: ReactionFeedViewInput) {
        _view = view
    }
}
