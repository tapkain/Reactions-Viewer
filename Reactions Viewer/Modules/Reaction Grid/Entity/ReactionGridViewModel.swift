//
//  ReactionGridViewModel.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/3/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public struct ReactionGridViewModel: Hashable, Equatable {
    public let id: String
    public var thumbnail: UIImage?
    public var hashValue: Int {
        return id.hashValue
    }
}
