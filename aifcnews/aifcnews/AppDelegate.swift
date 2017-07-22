//
//  AppDelegate.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/13/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import TabPageViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = configureTabBarVC()
        window?.makeKeyAndVisible()
        return true
    }
    
    func configureTabBarVC() -> TabPageViewController {
        let tabPageViewController = TabPageViewController.create()
        tabPageViewController.option.fontSize = 11
        tabPageViewController.option.hidesTopViewOnSwipeType = .tabBar
        tabPageViewController.option.isTranslucent = false
        tabPageViewController.option.currentColor = .white
        tabPageViewController.option.defaultColor = .lightGray
        tabPageViewController.option.tabHeight = 40
        tabPageViewController.option.hidesTopViewOnSwipeType = .navigationBar
        tabPageViewController.option.hidesTopViewOnSwipeType = .tabBar
        tabPageViewController.hidesBottomBarWhenPushed = true
        tabPageViewController.isInfinity = true
        tabPageViewController.option.tabBackgroundColor = .mainBlue
        tabPageViewController.option.highlightFontName = "OpenSans-Semibold"
        tabPageViewController.option.unHighlightFontName = "OpenSans-Semibold"
        tabPageViewController.tabItems = [(FeedViewController(), "ECONOMY"), (FeedViewController(), "KAZAKHSTAN"), (FeedViewController(), "AIFC"), (FeedViewController(), "BITCOIN")]
        return tabPageViewController
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

