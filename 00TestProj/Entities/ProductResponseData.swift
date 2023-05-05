//
//  ProductResponseData.swift
//  00TestProj
//
//  Created by Александр Фофонов on 05.05.2023.
//

import Foundation

struct ProductResponseData: Decodable {
    let products: [Product]?
    let count: Int
    let title: String
}
