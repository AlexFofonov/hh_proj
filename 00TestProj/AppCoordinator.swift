//
//  AppCoordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.04.2023.
//

import UIKit

final class AppCoordinator: Coordinator<Assembly, UINavigationController, Any> {
    
    override func make() -> UIViewController? {
        let navigationController = assembly.navigationController
        
        let coordinator = assembly.authCoordinator()
        
        start(
            coordinator: coordinator,
            on: navigationController,
            animated: false
        )
        
        return navigationController
    }
    
}
