//
//  Hat.swift
//  SwiftUI-List
//
//  Created by Ethan on 19/04/2022.
//

import Foundation

// MARK: - Hat
struct Hat: Codable, Identifiable {
    let id, type, animal, title: String
    let size, hatDescription: String
    let pic: String

    enum CodingKeys: String, CodingKey {
        case id, type, animal, title, size
        case hatDescription = "description"
        case pic
    }
}

extension Hat: Equatable {
    
}
