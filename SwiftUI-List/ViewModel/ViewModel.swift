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

extension ViewModel {
    // for testing purposes
    @MainActor
    func fetchEmployees(latency: Double = 3.0) async  {

        fetching = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + latency) {
            self.employees.append(Employee(id: "1111",
                                           name: "Test1",
                                           title: "title1",
                                           address: Address(street: "street", city: "city", zip: 11111),
                                           pic: "https://cdn-icons-png.flaticon.com/512/190/190682.png"))
            self.employees.append(Employee(id: "2222",
                                           name: "Test2",
                                           title: "title2",
                                           address: Address(street: "street", city: "city", zip: 22222),
                                           pic: "https://cdn4.iconfinder.com/data/icons/business-users-1/256/woman_black_business.png"))
            self.employees.append(Employee(id: "3333",
                                           name: "Test3",
                                           title: "title3",
                                           address: Address(street: "street", city: "city", zip: 33333),
                                           pic: "https://cdn-icons-png.flaticon.com/512/190/190682.png"))

            self.fetching = false
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
