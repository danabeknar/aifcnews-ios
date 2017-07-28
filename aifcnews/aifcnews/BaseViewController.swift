//
//  BaseViewController.swift
//  
//
//  Created by Beknar Danabek on 7/27/17.
//
//

import UIKit
import PageMenu

class BaseViewController: UIViewController, CAPSPageMenuDelegate {

    var pageMenu : CAPSPageMenu?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var controllerArray : [UIViewController] = []
        
        let controller : UIViewController = FeedViewController()
        controller.title = "Kazakhstan"
        
        let controller2 : UIViewController = FeedViewController()
        controller2.title = "Economy"
        
        let controller3 : UIViewController = FeedViewController()
        controller3.title = "Bitcoin"
        
        controllerArray.append(contentsOf: [controller, controller2, controller3])
        
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
}
