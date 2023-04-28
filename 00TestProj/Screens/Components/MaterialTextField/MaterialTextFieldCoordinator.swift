//
//  MaterialTextFieldCoordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 20.04.2023.
//

import Foundation
import UIKit

final class MaterialTextFieldCoordinator: Coordinator<Assembly, UINavigationController, MaterialTextFieldContext> {
    
    override func make() -> UIViewController? {
        guard let context = context else {
            return nil
        }
        
        let controller = assembly.materialTextFieldVC(
            labelText: context.labelText,
            keyboardType: context.keyboardType
        )
        controller.setFieldChanged = context.setFieldChanged
    
        return controller
    }
    
}

