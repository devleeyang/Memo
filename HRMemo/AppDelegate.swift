//
//  AppDelegate.swift
//  HRMemo
//
//  Created by 양혜리 on 19/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow()
        IQKeyboardManager.shared.enable = true
        
        let introViewController = HRIntroViewController()
        window?.rootViewController = introViewController
        window?.makeKeyAndVisible()
        return true
    }
}

