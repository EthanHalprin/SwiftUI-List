//
//  Store.swift
//  SwiftUI-List
//
//  Created by Ethan on 19/04/2022.
//

import Foundation

// MARK: - Welcome
struct StoreContainer: Codable {
    let store: Store
}

// MARK: - Store
struct Store: Codable {
    let hats: [Hat]
}

