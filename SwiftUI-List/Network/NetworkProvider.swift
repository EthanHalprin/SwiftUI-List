//
//  NetworkProvider.swift
//  SwiftUI-List
//
//  Created by Ethan on 13/03/2022.
//
import Foundation
import Combine


class NetworkProvider: ObservableObject {
    
    var cancellable: AnyCancellable?
    fileprivate var url: String
    
    init(_ url: String) {
        self.url = url
    }
    
    func fetch<T: Decodable>(_ callback: @escaping (T) -> Void) throws {
        
        // Define url according to endpoint found
        let url = URL(string: url)!
        
        // Build publisher to decode this T type
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .tryMap() { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                    httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {
                    print ("Received completion: \($0).")
                  },
                  receiveValue: { T in
                    print ("Received: \(T)")
                    callback(T)
            })
    }
}
