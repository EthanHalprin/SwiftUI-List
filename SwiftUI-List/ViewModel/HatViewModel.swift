//
//  HatViewModel.swift
//  SwiftUI-List
//
//  Created by Ethan on 19/04/2022.
//

import Foundation
import SwiftUI

class HatViewModel: ObservableObject {
    
    var hat: Hat
    var cache: Cache<String, Image>

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let width: CGFloat = 45
    let height: CGFloat = 45
    let trailingPadder: CGFloat = 10
    let topPadder: CGFloat = 7
    let primaryFontSize: CGFloat = 13
    let secondaryFontSize: CGFloat = 11
    
    required init(hat: Hat, cache: Cache<String, Image>) {
        self.hat = hat
        self.cache = cache
    }
}
