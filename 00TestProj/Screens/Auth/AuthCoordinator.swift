//
//  AuthCoordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.04.2023.
//

import UIKit

final class AuthCoordinator: Coordinator<Assembly, UINavigationController, Any> {
    
    override func make() -> UIViewController? {
        let controller = assembly.authVC()

        setContent(
            coordinator: assembly.phoneMaterialTextFieldCoordinator(
                setFieldChanged: { [weak controller] data in
                    guard let controller = controller else {
                        return nil
                    }
                    
                    controller.change(phone: data.text)
                    
                    return controller.validatePhone()
                }
            ),
            on: controller,
            containerId: .phone
        )
        
        controller.onVerification = { [weak self] phone, completion in
            guard let self = self else {
                return
            }

            let coordinator = self.assembly.verificationCoordinator(
                context: .init(
                    phone: phone,
                    timeLimit: 15,
                    finishFlow: { [weak self] operationToken in
                        guard let self = self else {
                            return
                        }
                        
                        completion(operationToken)
                        
                        self.start(coordinator: self.assembly.catalogCoordinator(), on: self.root, animated: true)
                    }
                )
            )

            self.start(
                coordinator: coordinator,
                on: self.root,
                animated: true
            )
        }
        
        return controller
    }

}
