//
//  SceneDelegate.swift
//  Simple weather app
//
//  Created by Maksim Matveichuk on 23.Jun.22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let navigationController = UINavigationController()
        let startViewController = ViewControllerFactory.makeViewController()
        navigationController.viewControllers = [startViewController]
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }


}

