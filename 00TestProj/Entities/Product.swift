//
//  Product.swift
//  00TestProj
//
//  Created by Александр Фофонов on 05.05.2023.
//

import Foundation

struct Product: Codable {
    let id: Int
    let imageURL: URL
    let name: String
    let rating: Int
    let price: String
}
