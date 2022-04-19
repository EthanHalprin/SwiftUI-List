//
//  HatViewModel.swift
//  SwiftUI-List
//
//  Created by Ethan on 19/04/2022.
//

import Foundation
import SwiftUI

class HatViewModel: ObservableObject {
    
    @Published var picTimeout = 3
    var hat: Hat? = nil
    var cache: ImageCache? = nil

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let width: CGFloat = 45
    let height: CGFloat = 45
    let trailingPadder: CGFloat = 10
    let topPadder: CGFloat = 7
    let primaryFontSize: CGFloat = 13
    let secondaryFontSize: CGFloat = 11
    
    required init(hat: Hat, cache: ImageCache, picTimeout: Int = 5) {
        self.hat = hat
        self.cache = cache
        self.picTimeout = picTimeout
    }
}
