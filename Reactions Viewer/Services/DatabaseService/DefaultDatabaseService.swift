//
//  DefaultDatabaseService.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation
import RealmSwift

public final class DefaultDatabaseService: DatabaseService {
    private let _key: String
    private let _workerQueue: DispatchQueue
    
    public init(key: String) {
        _key = key
        _workerQueue = DispatchQueue(label: "RTDatabase" + key, qos: .utility)
    }
    
    public enum RealmStorageError: Error {
        case failedFetch
    }
    
    /// Creates Realm object on designated thread. This gives you oportunity to query some object in a thread-safe environment or resolve ThreadSafeReference before performing writes.
    ///
    /// - Parameter block: accepts a newely created Realm object. which relates to a designated database thread.
    public func open(_ block: @escaping (Realm?) -> Void) {
        _workerQueue.async {
            do {
                block(try Realm())
            } catch(let error) {
                #if DEBUG
                fatalError(error.localizedDescription)
                #else
                block(nil)
                #endif
            }
        }
    }
    
    /// Performs synchronouse write operation on provided Realm object or creates new Realm on caller's thread.
    ///
    /// - Parameters:
    ///   - realm: Realm object on which to perform write. Creates new if not provided
    ///   - block: write operation
    /// - Returns: Success of write operation
    public func write(toRealm realm: Realm? = nil,
                      block: @escaping RTCompletionVoid) -> Bool {
        do {
            let _realm = try realm ?? Realm()
            try _realm.write {
                block()
            }
            return true
        } catch(let error) {
            #if DEBUG
            fatalError(error.localizedDescription)
            #else
            return false
            #endif
        }
    }
    
    public func openAndWrite(_ block: @escaping (Realm) -> Void,
                             completion: RTCompletionBool? = nil) {
        open { (realm) in
            guard let realm = realm else {
                completion?(false)
                return
            }
            
            do {
                try realm.write {
                    block(realm)
                }
                completion?(true)
            } catch(let error) {
                #if DEBUG
                fatalError(error.localizedDescription)
                #else
                completion?(false)
                #endif
            }
        }
    }
    
    private var _reactionsFeed: ReactionListObject? {
        do {
            let realm = try Realm()
            var feed = realm.object(ofType: ReactionListObject.self, forPrimaryKey: _key)
            
            if feed == nil {
                feed = ReactionListObject(key: _key)
                try realm.write {
                    realm.add(feed!)
                }
            }
            return feed
        } catch (let error) {
            print("Failed to create Feed object, error: \(error)")
            return nil
        }
    }
    
    public func observeReactionList(onSubscribed: @escaping ([ReactionObject]) -> Void,
                                    onUpdated: @escaping ([ReactionObject], [Int], [Int], [Int]) -> Void,
                                    onFailed: @escaping (Error) -> Void) -> DatabaseNotificationToken? {
        let realmToken = _reactionsFeed?.reactions.observe({ (change) in
            switch change {
            case .initial(let result):
                onSubscribed(Array(result))
            case .update(let result, let deletions, let insertions, let modifications):
                onUpdated(Array(result), deletions, insertions, modifications)
            case .error(let error):
                onFailed(error)
            }
        })
        
        if let realmToken = realmToken {
            return DatabaseNotificationToken(realmToken: realmToken)
        } else {
            return nil
        }
    }
    
    #if DEBUG
    public func deleteAllReactions(completion: RTCompletionBool?) {
        openAndWrite({ (realm) in
            realm.delete(realm.objects(ReactionObject.self))
        }, completion: completion)
    }
    #endif
    
    public func purgeReactionFeed(completion: RTCompletionBool?) {
        openAndWrite({ (_) in
            self._reactionsFeed?.reactions.removeAll()
        }, completion: completion)
    }
    
    public func reactionListAppend(reactions: [ReactionObject],
                                   users: [UserObject],
                                   completion: RTCompletionBool?) {
        open { (realm) in
            func appendReactionsToFeed() {
                let ids = reactions.compactMap { $0.id }
                guard let managedReactions = ReactionObject.fetchAll(withPrimaryKeys: ids, realm: realm),
                    let reactionsFeed = self._reactionsFeed else {
                        return
                }
                
                let uniqueReactions = managedReactions.filter { (managedReaction) in
                    !reactionsFeed.reactions.contains(where: {
                        $0.id == managedReaction.id
                    })
                }
                reactionsFeed.reactions.append(objectsIn: uniqueReactions)
            }
            
            guard let realm = realm else {
                completion?(false)
                return
            }
            
            let success = self.write(toRealm: realm) {
                users.forEach {
                    let _ = self.addUser($0, realm: realm)
                }
                reactions.forEach {
                    let _ = self.addReaction($0, realm: realm)
                }
                
                appendReactionsToFeed()
            }
            
            completion?(success)
        }
    }
    
    public func observe<ObjectType: Object>(
        objectType: ObjectType.Type,
        predicate: NSPredicate? = nil,
        initialBlock: @escaping ([ObjectType]) -> Void,
        updateBlock: @escaping ([ObjectType], [Int], [Int], [Int]) -> Void,
        errorBlock: @escaping (Error) -> Void)
        -> DatabaseNotificationToken? where ObjectType: RTRealmStorable {
            guard let managedObjects: Results<ObjectType> = objectType.fetch(predicate: predicate) else {
                errorBlock(RealmStorageError.failedFetch)
                return nil
            }
            
            let realmToken =  managedObjects.observe({ (change) in
                switch change {
                case .initial(let result):
                    initialBlock(Array(result))
                case .update(let result, let deletions, let insertions, let modifications):
                    updateBlock(Array(result), deletions, insertions, modifications)
                case .error(let error):
                    errorBlock(error)
                }
            })
            
            return DatabaseNotificationToken(realmToken: realmToken)
    }
    
    public func addUser(_ unmanagedUser: UserObject,
                        realm: Realm) -> UserObject? {
        func getManagedUser() -> UserObject? {
            return realm.object(ofType: UserObject.self,
                                forPrimaryKey: unmanagedUser.id)
        }
        
        guard let managedUser = getManagedUser() else {
            realm.add(unmanagedUser, update: false)
            return getManagedUser()
        }
        
//        if !managedUser.isEqual(to: unmanagedUser) {
//            managedUser.update(with: unmanagedUser)
//        }
        
        if let reactions: Results<ReactionObject> = ReactionObject.fetch(predicate: NSPredicate(format: "reactionOwnerId IN %@", [unmanagedUser.id]), realm: realm) {
            let matchedReactions = reactions
                .filter {
                    return $0.reactionOwnerId == managedUser.id
                }.filter {
                    return !managedUser.reactions.contains($0)
            }
            managedUser.reactions.append(objectsIn: matchedReactions)
        }
        
        return managedUser
    }
    
    public func addReaction(_ unmanagedReaction: ReactionObject,
                            realm: Realm) -> ReactionObject? {
        func getManagedReaction() -> ReactionObject? {
            return realm.object(ofType: ReactionObject.self,
                                forPrimaryKey: unmanagedReaction.id)
        }
        
        func addAndSetRelations() -> ReactionObject? {
            func getReactionOwner() -> UserObject? {
                return realm.object(ofType: UserObject.self,
                                    forPrimaryKey: unmanagedReaction.reactionOwnerId)
            }
            
            realm.add(unmanagedReaction)
            
            if let managedReaction = getManagedReaction() {
                if let reactionOwner = getReactionOwner() {
                    reactionOwner.reactions.append(managedReaction)
                }
            }
            return getManagedReaction()
        }
        
        if let managedReaction = getManagedReaction() {
//            if !managedReaction.isEqual(to: unmanagedReaction) {
//                managedReaction.update(with: unmanagedReaction)
//            }
            return managedReaction
        } else {
            return addAndSetRelations()
        }
    }
}

extension DatabaseNotificationToken {
    public convenience init(realmToken: NotificationToken) {
        self.init {
            realmToken.invalidate()
        }
    }
}
