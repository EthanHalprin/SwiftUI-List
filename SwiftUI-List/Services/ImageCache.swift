//
//  ImageCache.swift
//  SwiftUI-List
//
//  Created by Ethan on 04/04/2022.
//
import Foundation
import SwiftUI


final class Cache<Key: Hashable, Value> {
    private let cacheRef = NSCache<WrappedKey, Entry>()
    
    func insert(_ value: Value, forKey key: Key) {
        let entry = Entry(value: value)
        cacheRef.setObject(entry, forKey: WrappedKey(key))
    }
    
    func value(forKey key: Key) -> Value? {
        let entry = cacheRef.object(forKey: WrappedKey(key))
        print(entry == nil ? "-----------CACHE MISS-----------" : "-----------CACHE HIT-----------")
        return entry?.value
    }
    
    func removeValue(forKey key: Key) {
        cacheRef.removeObject(forKey: WrappedKey(key))
    }
    
    func flush() {
        cacheRef.removeAllObjects()
    }
    
    subscript(key: Key) -> Value? {
        get {
            return value(forKey: key)
        }
        set {
            guard let value = newValue else {
                // If nil was assigned using our subscript,
                // then we remove any value for that key:
                removeValue(forKey: key)
                return
            }
            insert(value, forKey: key)
        }
    }
}

private extension Cache {
    final class WrappedKey: NSObject {
        let key: Key

        init(_ key: Key) { self.key = key }

        override var hash: Int { return key.hashValue }

        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }

            return value.key == key
        }
    }
}

private extension Cache {
    final class Entry {
        let value: Value

        init(value: Value) {
            self.value = value
        }
    }
}
