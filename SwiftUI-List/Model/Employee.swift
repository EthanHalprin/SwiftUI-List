//
//  Employee.swift
//  SwiftUI-List
//
//  Created by Ethan on 13/03/2022.
//

import Foundation

// MARK: - CompanyContainer
struct CompanyContainer: Codable {
    let company: Company
}

// MARK: - Company
struct Company: Codable {
    let brand: String
    let employees: [Employee]
}

// MARK: - Employee
struct Employee: Codable, Identifiable {
    let id, name, title: String
    let address: Address
    let pic: String

    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case name, title, address, pic
    }
}

// MARK: - Address
struct Address: Codable {
    let street, city: String
    let zip: Int
}

// MARK: - Address
extension Employee: Equatable {
    static func == (lhs: Employee, rhs: Employee) -> Bool {
        return lhs.id == rhs.id
    }
}

