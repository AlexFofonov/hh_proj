//
//  Assembly+NavigationController.swift
//  00TestProj
//
//  Created by Александр Фофонов on 13.04.2023.
//

import UIKit

extension Assembly {
    
    var navigationController: UINavigationController {
        let controller = UINavigationController()
        
        controller.navigationBar.backIndicatorImage = UIImage(named: "NavigationBar/Arrow")
        controller.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "NavigationBar/Arrow")
        controller.navigationBar.tintColor = UIColor(named: "Colors/Black")
        controller.navigationBar.barTintColor = UIColor(named: "Colors/Background")
        controller.navigationBar.shadowImage = UIImage()
        
        return controller
    }
    
}
