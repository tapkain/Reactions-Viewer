//
//  UserObject.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/2/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation

import RealmSwift
import Realm

@objcMembers
public final class UserObject: Object {
    dynamic public var id: String = ""
    dynamic public var displayname: String = ""
    dynamic public var username: String = ""
    //MediaFiles
//     fileprivate let _avatars = List<RTAvatarImageDescription>()
    dynamic public var avatarKey: String = ""
    //Relations
    public let reactions = List<ReactionObject>()
    override public class func primaryKey() -> String? {
        return "id"
    }
    
    public init(withUser user: User) {
        super.init()
        self.id = user.id ?? ""
        self.displayname = user.displayname ?? ""
        self.username = user.username ?? ""
        let avatarFile = user.avatarFiles?.first(where: {
            return $0.type == .full
        })
        self.avatarKey = avatarFile?.key ?? ""
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
