//
//  CatalogCoordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

final class CatalogCoordinator: Coordinator<Assembly, UINavigationController, Any> {
    
    override func make() -> UIViewController? {
        let controller = assembly.catalogVC()
        
        return controller
    }
    
}
