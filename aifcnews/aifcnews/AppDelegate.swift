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
        SideMenuController.preferences.drawing.sidePanelWidth = Helper.shared.constrain(with: .width, num: 247)
        SideMenuController.preferences.drawing.centerPanelShadow = true
        SideMenuController.preferences.animating.statusBarBehaviour = .showUnderlay
    }
    
    func setupWindow(){
        UIApplication.shared.isStatusBarHidden = true
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = getRootViewController()
        self.window?.makeKeyAndVisible()
    }
    
    func getRootViewController() -> SideMenuController {
        let sideMenuViewController = SideMenuController()
        sideMenuViewController.delegate = self
        let vc1 = FeedViewController()
        let tags = fetchTags()
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
    
    func fetchTags() -> [Tag] {
        var tags = [Tag]()
        if let data = UserDefaults.standard.object(forKey: "tags") as? Data,
            let subtags = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Subtag] {
            tags = AppDelegate.transform(selectedSubtags: subtags)
        }
        if tags.isEmpty { tags = Tag.fetchTags() }
        return tags
    }
    
    static func transform(selectedSubtags: [Subtag]) -> [Tag] {
        var selectedTags = [Tag]()
        let tags = Tag.fetchTags()
        let selectedSubtagsTexts = selectedSubtags.flatMap{ $0.subtag }

        for tag in tags {
            var subtags = [Subtag]()
            for subtag in tag.subtags {
                if selectedSubtagsTexts.contains(subtag.subtag) {
                    subtags.append(subtag)
                    
                }
            }
            if !subtags.isEmpty {
                let newTag = Tag(tag.tag, tag.color, subtags, tag.collapsed)
                selectedTags.append(newTag)
            }
        }
        
        if selectedTags.isEmpty { selectedTags = tags }
        return selectedTags
    }

    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        SVProgressHUD.dismiss()
    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        print("hide")
    }
    
}

