//
//  SceneDelegate.swift
//
//
//  Created by Александр Фофонов on 27.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    let assembly = Assembly()
    lazy var navigationController = assembly.navigationController

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        let appCoordinator = assembly.appCoordinator()
        let rootController = appCoordinator.make()
        self.appCoordinator = appCoordinator
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }

}

