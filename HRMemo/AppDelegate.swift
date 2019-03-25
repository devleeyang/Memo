//
//  AppDelegate.swift
//  HRMemo
//
//  Created by 양혜리 on 19/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        let mainVC = HRListViewController()
        let navi = UINavigationController(rootViewController: mainVC)
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        return true
    }
}

