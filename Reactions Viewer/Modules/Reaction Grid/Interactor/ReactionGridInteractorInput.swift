//
//  ReactionGridInteractorInput.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public protocol ReactionGridInteractorInput {
    func downloadThumbnail(id: String)
    
    func cancelDownload(id: String)
    
    func stopObservingReactions()
    
    func observeReactions()
}
