//
//  ImageCache.swift
//  SwiftUI-List
//
//  Created by Ethan on 04/04/2022.
//
import Foundation
import SwiftUI


class suString: NSObject {
    var data = ""
    
    init(_ data: String) {
        self.data = data
    }
}

class suImage: NSObject {
    var image = Image("")

    init(_ image: Image) {
        self.image = image
    }
}

class ImageCache {
    private let cache = NSCache<suString, suImage>()
    
    init() {
        // maximum fixed cost: 100MB
        cache.totalCostLimit = 100_000_000
    }
    
    func getImage(by url: String) -> Image? {
        
        let key = suString(url)
        
        if let cachedImage = cache.object(forKey: key) {
            print("----------- Cache Hit √ -------------------")
            return cachedImage.image
        } else {
            print("----------- Cache Miss X ------------------")
            return nil
        }
    }
    
    func setImage(_ image: Image, url: String) {
        let img = suImage(image)
        let key = suString(url)
        cache.setObject(img, forKey: key)
    }
}


