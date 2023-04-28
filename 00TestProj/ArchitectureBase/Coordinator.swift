//
//  Coordinator.swift
//  00TestProj
//
//  Created by Александр Фофонов on 14.04.2023.
//

import Foundation
import UIKit

class Coordinator<AssemblyType: Assembly, NavigationControllerType, ContextType>: BaseCoordinator, RootedCoordinator {
    
    // MARK: - BaseCoordinator
    var parentCoordinator: BaseCoordinator?
    var children: [BaseCoordinator] = []
    
    func make() -> UIViewController? {
        return nil
    }
    
    // MARK: - RootedCoordinator
    var root: NavigationControllerType?
    
    // MARK: - Init
    init(assembly: AssemblyType, context: ContextType?) {
        self.assembly = assembly
        self.context = context
    }
    
    init(assembly: AssemblyType) {
        self.assembly = assembly
        self.context = nil
    }
    
    let assembly: AssemblyType
    let context: ContextType?
    
}

