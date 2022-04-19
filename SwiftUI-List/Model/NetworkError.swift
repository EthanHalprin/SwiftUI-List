//
//  NetworkError.swift
//  SwiftUI-List
//
//  Created by Ethan on 19/04/2022.
//

import Foundation

struct NetworkError: Identifiable {
    var id = UUID()
    var code: Int
    var title: String
    var description: String
}
