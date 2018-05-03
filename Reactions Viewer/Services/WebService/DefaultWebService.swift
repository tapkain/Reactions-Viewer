//
//  DefaultWebService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public final class DefaultWebService: WebService {
    public func getReactions(startKey: String? = nil, completion: @escaping ReactionsFeedCompletion) {
        ReactionAPI.getReactions(type: .hot,
                                 startKey: startKey,
                                 includeUserModels: ._true,
                                 completion: completion)
    }
}
