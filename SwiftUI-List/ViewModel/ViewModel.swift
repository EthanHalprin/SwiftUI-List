//
//  ViewModel.swift
//  SwiftUI-List
//
//  Created by Ethan on 13/03/2022.
//
import Foundation
import SwiftUI


class ListViewModel: ObservableObject {
    
    @Published var hats = [Hat]()
    @Published var fetching = false
    @Published var didError = false
    fileprivate let dataUrl = "https://raw.githubusercontent.com/EthanHalprin/OrderingAppData/main/storeData.json?token=GHSAT0AAAAAABTXEURG7CYGOFOJOIXKNFGOYS7DP4A"
    var networkError: NetworkError?
    var cache = ImageCache()
    private var lastFetchTimestamp: TimeInterval?
    private lazy var network = NetworkService()
    
    
    func fetchMerchandise() async throws {
        
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
        
        DispatchQueue.main.async {
            self.fetching = true
        }
        
        do {
            try network.fetch(from: dataUrl, { [weak self] (container: StoreContainer) -> Void in
                guard let self = self else { return }
                self.hats = container.store.hats
                self.lastFetchTimestamp = NSDate().timeIntervalSince1970
                self.fetching = false // since no other threads change 'fetching', no need to mutex it
            })
        } catch let error as URLError {
            throw error
        }
    }
    
    // cannot throw on this one, due to the fact it is used from Button press handler
    func refreshMerchandise() {
        
        fetching = true
        
        ImageCache.flush()
        self.hats.removeAll()
        
        try? network.fetch(from: dataUrl, { [weak self] (container: StoreContainer) -> Void in
            guard let self = self else { return }
            self.hats = container.store.hats
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
