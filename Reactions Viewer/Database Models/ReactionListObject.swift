//
//  ReactionsFeedObject.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/2/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import RealmSwift
import Realm

@objcMembers public class ReactionListObject: Object {
    dynamic public var key: String = ""
    public let reactions = List<ReactionObject>()
    
    public convenience init(key: String) {
        self.init()
        self.key = key
    }
    
    override public class func primaryKey() -> String? {
        return "key"
    }
}
