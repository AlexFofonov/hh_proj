//
//  AuthCoordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.04.2023.
//

import UIKit

final class VerificationCoordinator: Coordinator<Assembly, UINavigationController, VerificationContext> {
    
    override func make() -> UIViewController? {
        guard let context = context else {
            return nil
        }
        
        let controller = assembly.verificationVC(
            phone: context.phone,
            timeLimit: context.timeLimit
        )
        
        controller.onComplete = { operationToken in
            context.finishFlow(operationToken)
        }
        
        return controller
    }
    
}
