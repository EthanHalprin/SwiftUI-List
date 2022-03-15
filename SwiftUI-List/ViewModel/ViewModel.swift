//
//  ViewModel.swift
//  SwiftUI-List
//
//  Created by Ethan on 13/03/2022.
//
import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var employees = [Employee]()
    var employeesDataLink: String
    var network: NetworkService?

    required init(url: String) {
        if url.isValidURL {
            employeesDataLink = url
        } else {
            fatalError("PresenterViewModel: bad url for employees data")
        }
    }
    
    func fetchEmployees() async throws {
        network = NetworkService()
        
        do {
            try network!.fetch(from: employeesDataLink, { [weak self] (container: CompanyContainer) -> Void in
                guard let self = self else { return }
                self.employees = container.company.employees
                print("\n\nFetched \(self.employees.count) employees:")
                print("-----------------------------------------")
                for employee in self.employees {
                    print("\(employee)")
                }
                print("-----------------------------------------\n\n")

                self.network = nil
            })
        } catch let error as URLError {
            throw error
        }
    }
 }

extension String {
    var isValidURL: Bool {
        if let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
           let firstMatch = detector.firstMatch(in: self,
                                                options: [],
                                                range: NSRange(location: 0, length: self.utf16.count)) {
            return firstMatch.range.length == self.utf16.count // match needs to occupy string fully
        } else {
            return false
        }
    }
}
