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
    fileprivate let dataUrl = "https://gist.githubusercontent.com/raw/3b15d0220b17236514acf8803835ded6/hat_store.json"
    var networkError: NetworkError?
    var cache = ImageCache()
    private var lastFetchTimestamp: TimeInterval?
    private lazy var network = NetworkService()
    
    
    func fetchData() async throws {
        
        //
        // Testing the network error .alert :
        // Uncomment this block.
        //
        // *TBD - this is temp. Need to devise a Test for this
        //
        /*
        let code = URLError.Code(rawValue: 500)
        let err = URLError(code)
        throw err
        return
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
                DispatchQueue.main.async {
                    // since no other threads change 'fetching', no need to mutex it
                    self.fetching = false
                }
            })
        } catch let error as URLError {
            throw error
        }
    }
    
    // cannot throw on this one, due to the fact it is used from Button press handler
    func refreshMerchandise() {
        
        DispatchQueue.main.async {
            self.fetching = true
        }
        
        ImageCache.flush()
        self.hats.removeAll()
        
        try? network.fetch(from: dataUrl, { [weak self] (container: StoreContainer) -> Void in
            guard let self = self else { return }
            self.hats = container.store.hats
            self.lastFetchTimestamp = NSDate().timeIntervalSince1970
            DispatchQueue.main.async {
                self.fetching = false
            }
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
