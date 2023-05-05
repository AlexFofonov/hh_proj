//
//  CatalogProviderImp.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import Foundation

class CatalogProviderImp: CatalogProvider {
    
    enum Constants {
        static let limit: Int = 10
    }
    
    init(decoder: JSONDecoder) {
        self.decoder = decoder
    }
    
    let decoder: JSONDecoder
    
    var loadedOffset: Int?
    var isLoading: Bool = false
    var isEnding: Bool = false
    
    func products(
        offset: Int,
        force: Bool,
        completion: @escaping (ProductResponseData?) -> Void
    ) {
        guard !isLoading else {
            return
        }
        
        guard let newOffset = nextAvailableOffset(offset: offset, force: force) else {
            return
        }
        
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.loadedOffset = newOffset
            self.isLoading = false
            
            guard
                let firstURL = Bundle.main.url(
                    forResource: "FirstProductsResponseData",
                    withExtension: "json"
                ),
                let secondURL = Bundle.main.url(
                    forResource: "SecondProductsResponseData",
                    withExtension: "json"
                ),
                let firstData = try? Data(contentsOf: firstURL),
                let secondData = try? Data(contentsOf: secondURL),
                let firstResponseBody = try? self.decoder.decode(ProductResponseData.self, from: firstData),
                let secondResponseBody = try? self.decoder.decode(ProductResponseData.self, from: secondData)
            else {
                return
            }
            
            if newOffset == 0 {
                completion(firstResponseBody)
            } else {
                completion(secondResponseBody)
                
                self.isEnding = true
            }
        }
    }
    
    func nextAvailableOffset(offset: Int, force: Bool) -> Int? {
        if force {
            return 0
        }
        
        if isEnding {
            return nil
        }
        
        if let loadedOffset = loadedOffset {
            if offset >= loadedOffset + Constants.limit / 2 {
                return loadedOffset + Constants.limit
            }
        } else if offset == 0 {
            return 0
        }
        
        return nil
    }
    
}
