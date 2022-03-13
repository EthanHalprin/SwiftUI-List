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
    fileprivate let networker: NetworkProvider!

    required init(contentLink: String) {
        if contentLink.isValidURL {
            networker = NetworkProvider(contentLink)
        } else {
            fatalError("PresenterViewModel: bad url")
        }
    }
    
    func load() {
        try? self.networker.fetch({ [weak self] (container: CompanyContainer) -> Void in
            guard let self = self else { return }
            self.employees = container.company.employees
            print(self.employees)
        })
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
