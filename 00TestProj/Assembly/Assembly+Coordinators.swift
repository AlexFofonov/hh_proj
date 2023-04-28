//
//  Assembly+Coordinators.swift
//  00TestProj
//
//  Created by Александр Фофонов on 23.04.2023.
//

import UIKit

extension Assembly {
    
    func appCoordinator() -> AppCoordinator{
        .init(assembly: self)
    }
    
    func authCoordinator() -> AuthCoordinator {
        .init(assembly: self)
    }
    
    func verificationCoordinator(context: VerificationContext?) -> VerificationCoordinator {
        .init(assembly: self, context: context)
    }
    
    func materialTextFieldCoordinator(context: MaterialTextFieldContext?) -> MaterialTextFieldCoordinator {
        .init(assembly: self, context: context)
    }
    
    func phoneMaterialTextFieldCoordinator(setFieldChanged: @escaping (_ data: MaterialTextFieldOutputData) -> LocalizedError?) -> MaterialTextFieldCoordinator {
        .init(
            assembly: self,
            context: .init(
                labelText: "Номер телефона",
                keyboardType: .asciiCapableNumberPad,
                setFieldChanged: setFieldChanged
            )
        )
    }
    
    func catalogCoordinator() -> CatalogCoordinator {
        .init(assembly: self)
    }
    
}
