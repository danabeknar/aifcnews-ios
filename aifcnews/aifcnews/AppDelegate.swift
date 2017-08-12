//
//  AppDelegate.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/13/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics
import RealmSwift
import SideMenuController
import SVProgressHUD

let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SideMenuControllerDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(0, forKey: "lastPressedCell")
        Fabric.with([Crashlytics.self])
        setupSideMenu()
        setupWindow()
        return true
    }

    func setupSideMenu(){
        SideMenuController.preferences.drawing.menuButtonImage = UIImage(named: "menuRed")
        SideMenuController.preferences.drawing.sidePanelPosition = .underCenterPanelLeft
        SideMenuController.preferences.drawing.sidePanelWidth = 250
        SideMenuController.preferences.animating.statusBarBehaviour = .slideAnimation
    }
    
    func setupWindow(){
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = getRootViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func getRootViewController() -> SideMenuController {
        let sideMenuViewController = SideMenuController()
        sideMenuViewController.delegate = self
        let vc1 = FeedViewController()
        let tags = AppDelegate.fetchTags()
        vc1.tags = tags
        vc1.initialTag = tags[0]
        let nc1 = UINavigationController(rootViewController: vc1)
        
        let sideController = MenuViewController()
        sideController.tags = tags
        sideController.initialTag = tags[0]
        sideMenuViewController.embed(sideViewController: sideController)
        sideMenuViewController.embed(centerViewController: nc1)
        [nc1].forEach({ controller in
            controller.addSideMenuButton()
        })
        return sideMenuViewController
    }
    
    static func fetchTags() -> [Tag] {
        var tags = [Tag]()
        if let data = UserDefaults.standard.object(forKey: "tags") as? Data,
               let tagsArray = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[Tag]] {
            tags = tagsArray[0]
        }
        if tags.isEmpty { tags = Tag.fetchTags() }
        return tags
    }

    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        SVProgressHUD.dismiss()
    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {}

}

