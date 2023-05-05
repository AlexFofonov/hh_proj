//
//  CatalogProvider.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import Foundation

protocol CatalogProvider {
    
    func products(offset: Int, force: Bool, completion: @escaping (ProductResponseData?) -> Void)
    
}
