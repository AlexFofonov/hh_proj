//
//  Assembly+AppCoordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 13.04.2023.
//

import Foundation

extension Assembly {
    
    func appCoordinator() -> AppCoordinator{
        .init(assembly: self)
    }
    
}
