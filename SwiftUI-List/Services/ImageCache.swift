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
    static var shared = NSCache<suString, suImage>()
    
    init() {
        // maximum fixed cost: 100MB
        ImageCache.shared.totalCostLimit = 100_000_000
    }
    
    static func getImage(by url: String) -> Image? {
        
        let key = suString(url)
        
        if let cachedImage = ImageCache.shared.object(forKey: key) {
            print("----------- Cache Hit √ -------------------")
            return cachedImage.image
        } else {
            print("----------- Cache Miss X ------------------")
            return nil
        }
    }
    
    static func setImage(_ image: Image, url: String) {
        let img = suImage(image)
        let key = suString(url)
        ImageCache.shared.setObject(img, forKey: key)
    }
    
    static func flush() {
        ImageCache.shared.removeAllObjects()
    }
}


