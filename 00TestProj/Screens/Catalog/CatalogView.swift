//
//  CatalogView.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

protocol CatalogView: UIView, UISearchBarDelegate, IndicationView {
    
    func display(title: String, animated: Bool)
    func display(cellData: [ProductCellData], animated: Bool)
    
}
