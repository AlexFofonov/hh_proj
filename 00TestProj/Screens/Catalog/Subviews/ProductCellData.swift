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
    
    let onFavoriteSubscriber: (
        _ cell: AnyObject,
        _ notify: @escaping CellButtonStateNotify
    ) -> Void
    
    let onFavoriteSelect: () -> Void
    
    let onSelect: () -> Void
}

struct CellButtonState {
    let isSelected: Bool
    let isLoading: Bool
}

typealias CellButtonStateNotify = (CellButtonState) -> Void
