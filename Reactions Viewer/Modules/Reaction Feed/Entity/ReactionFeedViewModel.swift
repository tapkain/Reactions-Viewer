//
//  ReactionFeedViewModel.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit

public struct ReactionFeedViewModel {
    let id: String
    let videoTitle: String
    let displayname: String
    let username: String
    let likesCount: Int64
    let commentsCount: Int64
    var thumbnail: UIImage?
    var avatar: UIImage?
}

extension ReactionFeedViewModel: Equatable {
    public static func == (lhs: ReactionFeedViewModel, rhs: ReactionFeedViewModel) -> Bool {
        return lhs.id == rhs.id
            && lhs.videoTitle == rhs.videoTitle
            && lhs.username == rhs.username
            && lhs.displayname == rhs.displayname
            && lhs.likesCount == rhs.likesCount
            && lhs.commentsCount == rhs.commentsCount
            && lhs.thumbnail == rhs.thumbnail
            && lhs.avatar == rhs.avatar
    }
}

extension ReactionFeedViewModel: Hashable {
    public var hashValue: Int {
        return id.hashValue
            ^ videoTitle.hashValue
            ^ displayname.hashValue
            ^ username.hashValue
            ^ likesCount.hashValue
            ^ commentsCount.hashValue
    }
}
