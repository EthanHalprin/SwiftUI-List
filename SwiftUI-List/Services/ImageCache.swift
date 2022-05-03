//
//  ImageCache.swift
//  SwiftUI-List
//
//  Created by Ethan on 04/04/2022.
//
import Foundation
import SwiftUI


class ImageCache {
    
    fileprivate static var cache = NSCache<CacheKey, CacheValue>()
    
    init() {
        // maximum fixed cost: 100MB
        ImageCache.cache.totalCostLimit = 100_000_000
    }
    
    static func getImage(by url: String) -> Image? {
        
        let key = CacheKey(url)
        
        if let cachedValue = ImageCache.cache.object(forKey: key) {
            print("----------- Cache Hit √ -------------------")
            return cachedValue.image
        } else {
            print("----------- Cache Miss X ------------------")
            return nil
        }
    }
    
    static func setImage(_ image: Image, url: String) {
        print("STORE:  \(url)")
        ImageCache.cache.setObject(CacheValue(image), forKey: CacheKey(url))
        
        if let cachedValue = ImageCache.cache.object(forKey: CacheKey(url)) {
            print("\(cachedValue.image)")
        }
    }
    
    static func flush() {
        ImageCache.cache.removeAllObjects()
    }
}

extension ImageCache {
    class CacheKey: NSObject {
        var data = ""
        
        init(_ data: String) {
            self.data = data
        }
    }

    class CacheValue: NSObject {
        var image = Image("")

        init(_ image: Image) {
            self.image = image
        }
    }
}


