//
//  CatalogView.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

protocol CatalogView: UIView, UISearchBarDelegate, IndicationView {
    
    var willDisplayProduct: ((_ item: Int) -> Void)? { get set }
    var onRefresh: (() -> Void)? { get set }
    
    func display(title: String, animated: Bool)
    func display(count: Int, animated: Bool)
    func display(cellData: [ProductCellData], append: Bool, animated: Bool)
    
}
