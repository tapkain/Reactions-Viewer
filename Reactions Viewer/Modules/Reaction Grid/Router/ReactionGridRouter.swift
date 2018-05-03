//
//  ReactionGridRouter.swift
//  ReactionsViewer
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public final class ReactionGridRouter: ReactionGridRouterInput {
    private weak var _view: ReactionGridViewInput?
    
    public init(view: ReactionGridViewInput) {
        _view = view
    }
}
