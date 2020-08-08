//
//  SceneDelegate.swift
//  QSResourceDirectory
//
//  Created by Ross Chea on 2020-08-07.
//  Copyright © 2020 Ross Chea. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let vc = CategoriesListVC()
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.tintColor = .primaryRed
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
}

