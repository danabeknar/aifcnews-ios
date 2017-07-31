//
//  BaseViewController.swift
//  
//
//  Created by Beknar Danabek on 7/27/17.
//
//

import UIKit
import PageMenu



class BaseViewController: UIViewController, CAPSPageMenuDelegate{



    var pageMenu : CAPSPageMenu?
    var tags = [Tag]()
    var controllerArray : [UIViewController] = []
    var tagsDictionary = [String: [String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        tags = Tag.fetchTags()
        
        for tag in tags {
            let controller : UIViewController = FeedViewController()
            controller.title = tag.tag
            controllerArray.append(controller)
        }
        
        let parameters: [CAPSPageMenuOption] = [
            .viewBackgroundColor(.backgroundGrey),
            .scrollMenuBackgroundColor(.mainBlue),
            .selectedMenuItemLabelColor(.white),
            .unselectedMenuItemLabelColor(.lightGray),
            .menuItemSeparatorColor(.white),
            .selectionIndicatorHeight(1),
            .menuItemFont(UIFont(name: "OpenSans-Semibold", size: 11)!),
            .menuItemWidthBasedOnTitleTextWidth(true),
            .menuItemSeparatorRoundEdges(true),
            .enableHorizontalBounce(true),
            .menuMargin(50),
            .addBottomMenuHairline(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0,y: 0.0,width: self.view.frame.width,height: self.view.frame.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        
        self.view.addSubview(pageMenu!.view)

        // Do any additional setup after loading the view.
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if UserDefaults.standard.object(forKey: "tags") != nil {
            print("da")
            let tags = UserDefaults.standard.object(forKey: "tags") as! [String: [String]]
            
            for (key,value) in tags {
                print(key)
                print(value)
                
//                
//                let controller : UIViewController = FeedViewController()
//                controller.title = tag.tag
//                controllerArray.append(controller)
            }
            
//            let parameters: [CAPSPageMenuOption] = [
//                .viewBackgroundColor(.backgroundGrey),
//                .scrollMenuBackgroundColor(.mainBlue),
//                .selectedMenuItemLabelColor(.white),
//                .unselectedMenuItemLabelColor(.lightGray),
//                .menuItemSeparatorColor(.white),
//                .selectionIndicatorHeight(1),
//                .menuItemFont(UIFont(name: "OpenSans-Semibold", size: 11)!),
//                .menuItemWidthBasedOnTitleTextWidth(true),
//                .menuItemSeparatorRoundEdges(true),
//                .enableHorizontalBounce(true),
//                .menuMargin(50),
//                .addBottomMenuHairline(true)
//            ]
//            
//            pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x:0.0,y: 0.0,width: self.view.frame.width,height: self.view.frame.height), pageMenuOptions: parameters)
//            
//            pageMenu!.delegate = self
//            
//            self.view.addSubview(pageMenu!.view)
            
        }
    }
    
}
