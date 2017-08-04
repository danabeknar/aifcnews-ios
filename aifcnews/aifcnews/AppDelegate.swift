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

let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        return true
    }

    func setupWindow() {
        Fabric.with([Crashlytics.self])
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainView = FeedViewController()
        
        var tags = [Tag]()
        if let data = UserDefaults.standard.object(forKey: "tags") as? Data,
            let subtags = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Subtag] {
            tags = AppDelegate.transform(selectedSubtags: subtags)
        }
        if tags.isEmpty { tags = Tag.fetchTags() }
        
        mainView.tags = tags
        mainView.initialTag = tags[0]
        self.window!.rootViewController = UINavigationController(rootViewController: mainView)
        self.window?.makeKeyAndVisible()
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
    
    func reloadPageMenu(with data: [Tag]) {
        let mainView = FeedViewController()
        mainView.tags = data
        window?.rootViewController = mainView
        window?.makeKeyAndVisible()
    }
}

