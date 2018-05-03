//
//  DatabaseService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation
import RealmSwift

public typealias RTCompletionVoid = () -> Void
public typealias RTCompletionBool = (Bool) -> Void

public protocol DatabaseService {
    init(key: String)
    func purgeReactionFeed(completion: RTCompletionBool?)
    func reactionListAppend(reactions: [ReactionObject], users: [UserObject], completion: RTCompletionBool?)
    #if DEBUG
    func deleteAllReactions(completion: RTCompletionBool?)
    #endif
    func observeReactionList(onSubscribed: @escaping ([ReactionObject]) -> Void,
                             onUpdated: @escaping ([ReactionObject], [Int], [Int], [Int]) -> Void,
                             onFailed: @escaping (Error) -> Void) -> DatabaseNotificationToken?
    
    func open(_ block: @escaping (Realm?) -> Void)
    func write(toRealm realm: Realm?, block: @escaping RTCompletionVoid) -> Bool
    func openAndWrite(_ block: @escaping (Realm) -> Void,
                      completion: RTCompletionBool?)
    func observe<ObjectType: Object>(
        objectType: ObjectType.Type,
        predicate: NSPredicate?,
        initialBlock: @escaping ([ObjectType]) -> Void,
        updateBlock: @escaping ([ObjectType], [Int], [Int], [Int]) -> Void,
        errorBlock: @escaping (Error) -> Void)
        -> DatabaseNotificationToken? where ObjectType: RTRealmStorable
}

public final class DatabaseNotificationToken {
    public init(invalidate: @escaping RTCompletionVoid) {
        self._invalidate = invalidate
    }

    deinit {
        invalidate()
    }
    
    public func invalidate() {
        _invalidate()
    }
    
    private let _invalidate: RTCompletionVoid
}
