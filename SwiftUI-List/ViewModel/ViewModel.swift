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
    @Published var fetching = false
    @Published var didError = false
    var networkError: NetworkError?

    var cache = ImageCache()
    private var lastFetchTimestamp: TimeInterval?
    private var dataLink: String
    private lazy var network = NetworkService()

    required init(url: String) {
        if url.isValidURL {
            dataLink = url
        } else {
            fatalError("PresenterViewModel: bad url for employees data")
        }
    }
    
    func fetchEmployees() async throws {
        
        /* Test Alert (to be removed)
         
        let code = URLError.Code(rawValue: 500)
        let err = URLError(code)
        throw err
         */

        if let lastFetch = self.lastFetchTimestamp {
            let currTime = NSDate().timeIntervalSince1970
            // 2 minutes refesh minimal
            guard currTime - lastFetch < 120.0 else {
                print("----- No Fetch (Refresh Time Quota) -------")
                return
            }
        }
        
        fetching = true

        do {
            try network.fetch(from: dataLink, { [weak self] (container: CompanyContainer) -> Void in
                guard let self = self else { return }
                self.employees = container.company.employees
                self.lastFetchTimestamp = NSDate().timeIntervalSince1970
                self.fetching = false // since no other threads change 'fetching', no need to mutex it
            })
        } catch let error as URLError {
            throw error
        }
    }
    
    // cannot throw on this one, due to the fact it is used from Button press handler
    func refreshEmployees() {
        
        fetching = true
        
        cache.flush()
        self.employees.removeAll()
        
        try? network.fetch(from: dataLink, { [weak self] (container: CompanyContainer) -> Void in
            guard let self = self else { return }
            self.employees = container.company.employees
            self.lastFetchTimestamp = NSDate().timeIntervalSince1970
            self.fetching = false // since no other threads change 'fetching', no need to mutex it
            print("------------- Refresh Done --------------")
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
