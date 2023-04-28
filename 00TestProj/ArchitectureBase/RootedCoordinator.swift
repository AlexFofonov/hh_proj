//
//  RootedCoordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 13.04.2023.
//

import Foundation
import UIKit

protocol RootedCoordinator: BaseCoordinator, AnyRootedCoordinator {
    
    associatedtype Root
    
    var root: Root? { get set }
    
}

extension RootedCoordinator {
    
    var anyRoot: Any? {
        root
    }
    
}

protocol AnyRootedCoordinator {
    
    var anyRoot: Any? { get }
    
}

extension RootedCoordinator where Root == UINavigationController {
    
    func backTo(coordinator: BaseCoordinator?, animated: Bool) {
        guard
            let coordinator = coordinator,
            let root = root
        else {
            return
        }
        
        let depth = coordinator.depth { ($0 as? AnyRootedCoordinator)?.anyRoot is UINavigationController }
        
        let newStack = root.viewControllers
            .prefix(max(root.viewControllers.count - depth - 1, 1))
        
        root.setViewControllers(Array(newStack), animated: animated)
    }
    
}
