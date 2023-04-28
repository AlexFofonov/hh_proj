//
//  ProductCellData.swift
//  00TestProj
//
//  Created by Александр Фофонов on 27.04.2023.
//

import Foundation

struct ProductCellData {
    let title: String
    let rating: Int
    let price: String
    
    let onSelect: () -> Void
}
