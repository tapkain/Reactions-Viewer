//
//  ReactionFeedInteractorOutput.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public protocol ReactionFeedInteractorOutput: class {
    func update(withThumbnail thumbnail: UIImage, forID id: String)
    
    func update(withAvatar avatar: UIImage, forID id: String)
    
    func update(withReactions reactions: [ReactionFeedViewModel])
    
    func update(isLoading: Bool, isFirstPage: Bool)
}


