//
//  BaseCoordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 03.04.2023.
//

import UIKit

protocol BaseCoordinator: AnyObject {
    
    var parentCoordinator: BaseCoordinator? { get set }
    var children: [BaseCoordinator] { get set }
    
    func make() -> UIViewController?
    
}

private extension BaseCoordinator {
    
    func addChild(coordinator: BaseCoordinator) {
        coordinator.parentCoordinator = self
        children.append(coordinator)
    }
    
}

extension BaseCoordinator {

    func start<Coordinator: RootedCoordinator>(
        coordinator: Coordinator?,
        on navigationController: UINavigationController?,
        animated: Bool
    ) where Coordinator.Root == UINavigationController {
        guard
            let coordinator = coordinator,
            let navigationController = navigationController,
            let controller = coordinator.make()
        else {
            return
        }
        
        addChild(coordinator: coordinator)
        
        coordinator.root = navigationController
        
        navigationController.pushViewController(
            controller,
            animated: !navigationController.viewControllers.isEmpty && animated)
    }
    
}

extension BaseCoordinator {
    
    func depth(where closure: (any BaseCoordinator) -> Bool) -> Int {
        let maxDepth = children
            .filter(closure)
            .compactMap { $0.depth(where: closure) }
            .max(by: >) ?? 0
        
        return maxDepth + 1
    }
    
}

extension BaseCoordinator {
    
    func setContent<VC: ContainerVC>(
        coordinator: BaseCoordinator?,
        on containerController: VC,
        containerId: VC.View.ContainerID
    ) {
        guard
            let coordinator = coordinator,
            let controller = coordinator.make()
        else {
            return
        }
        
        controller.willMove(toParent: containerController)
        containerController.addChild(controller)
        controller.didMove(toParent: containerController)
        
        addChild(coordinator: coordinator)
        
        containerController.hostView.addSubview(view: controller.view, by: containerId)
    }
    
    func removeContent<VC: ContainerVC>(
        coordinator: BaseCoordinator?,
        on containerController: VC,
        containerId: VC.View.ContainerID
    ) {
        guard
            let coordinator = coordinator,
            let controller = coordinator.make()
        else {
            return
        }

        controller.removeFromParent()
    }
    
}
