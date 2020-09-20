//
//  AppDelegate.swift
//  Superpeer
//
//  Created by abdbatue on 19.09.2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
                
        let nav = UINavigationController(rootViewController: ViewController())
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()

        return true
    }

}

