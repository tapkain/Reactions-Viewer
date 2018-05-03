//
//  WebService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

public protocol WebService {
    typealias ReactionsFeedCompletion = (_ data: ReactionList?,_ error: Error?) -> Void
    func getReactions(startKey: String?, completion: @escaping ReactionsFeedCompletion)
}
