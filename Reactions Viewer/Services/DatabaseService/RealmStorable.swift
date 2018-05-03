//
//  RealmStorable.swift
//  VIPER-REALM
//
//  Created by Oleksii Ozun on 5/1/18.
//  Copyright © 2018 Oleksii Ozun. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public protocol RTRealmStorable {}

extension NSPredicate {
    convenience init<K: Any>(primaryKey: String, values: [K]) {
        self.init(format: "\(primaryKey) IN %@", values)
    }
}

extension RTRealmStorable where Self: Object {
    static func fetchAll<K: Any>(withPrimaryKeys keys: [K]? = nil, realm: Realm? = nil) -> Results<Self>? {
        var predicate: NSPredicate?
        if let keys = keys {
            predicate = NSPredicate(primaryKey: Self.primaryKey() ?? "id", values: keys)
        }
        return Self.fetch(predicate: predicate, realm: realm)
    }
    
    static func fetchAll<K: AnyObject>(withPrimaryKeys keys: [K]? = nil, realm: Realm? = nil) -> [Self] {
        if let results: Results<Self> = fetchAll(withPrimaryKeys: keys, realm: realm) {
            return Array(results)
        } else {
            return []
        }
    }
    
    static func fetch(predicate: NSPredicate? = nil, realm: Realm? = nil) -> [Self] {
        if let results: Results<Self> = fetch(realm: realm) {
            return Array(results)
        } else {
            return []
        }
    }
    
    static func fetch(predicate: NSPredicate? = nil, realm: Realm? = nil) -> Results<Self>? {
        do {
            let realm = try realm ?? Realm()
            var allObjects = realm.objects(Self.self)
            if let predicate = predicate {
                allObjects = allObjects.filter(predicate)
            }
            
            return allObjects
        } catch (let error) {
            print("Failed to fetch \(Self.self), error: \(error)")
            return nil
        }
    }
    
    static func deleteAll(realm: Realm? = nil) {
        let keys: [String]? = nil
        if let results: Results<Self> = Self.fetchAll(withPrimaryKeys: keys, realm: realm) {
            results.forEach {
                $0.delete()
            }
        }
    }
    
    func save(realm: Realm? = nil) {
        do {
            let realm = try realm ?? Realm()
            try realm.write {
                realm.add(self)
            }
        } catch (let error) {
            print("Failed to save \(Self.self), error: \(error)")
        }
    }
    
    func delete(realm: Realm? = nil) {
        do {
            let realm = try realm ?? Realm()
            try realm.write {
                realm.delete(self)
            }
        } catch (let error) {
            print("Failed to delete \(Self.self), error: \(error)")
        }
    }
}
