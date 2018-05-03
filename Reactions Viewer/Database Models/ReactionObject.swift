//
//  ReactionObject.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

@objcMembers
public final class ReactionObject: Object {
    dynamic public var id: String = ""
    dynamic public var reactionOwnerId: String = ""
    dynamic public var contentVideoId: String = ""
    dynamic public var contentVideoOwnerId: String = ""
    //Presentation
    dynamic public var title: String = ""
    dynamic public var commentsCount: Int64 = 0
    dynamic public var likesCount: Int64 = 0
    //MediaFiles
    dynamic public var thumbnailKey: String = ""
//    public let videos = List<RTVideoFileDescription>()
    //Relations
    public let reactionOwner = LinkingObjects(fromType: UserObject.self, property: "reactions")
    
    public init(withReaction reaction: Reaction) {
        super.init()
        self.id = reaction.id?.uuidString ?? ""
        self.reactionOwnerId = reaction.userId ?? ""
        self.contentVideoId = reaction.originalVideoId?.uuidString ?? ""
        self.contentVideoOwnerId = reaction.originalVideoUserId ?? ""
        self.title = reaction.title ?? ""
        self.commentsCount = reaction.commentsCount ?? 0
        self.likesCount = reaction.likesCount ?? 0
        let thumbnailFile = reaction.thumbnailFiles?.first(where: {
            return $0.type == .full
        })
        self.thumbnailKey = thumbnailFile?.key ?? ""
    }
    
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    required public init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required public init() {
        super.init()
    }
    
    required public init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

extension ReactionObject: RTRealmStorable {
    
}
