//
//  BaseViewController.swift
//
//
//  Created by Beknar Danabek on 7/27/17.
//
//

import UIKit
import PageMenu
import ExpandingMenu



class BaseViewController: UIViewController, CAPSPageMenuDelegate{
    
    var pageMenu : CAPSPageMenu?
    var tags = [Tag]()
    var controllersArray : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)

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
        
        
        for i in tags {
            let vc = FeedViewController()
            let nVC = UINavigationController(rootViewController: vc)
            vc.title = i.tag
            controllersArray.append(nVC)
        }
        
        pageMenu = CAPSPageMenu(viewControllers: controllersArray, frame: CGRect(x:0.0,y: 0.0,width: self.view.frame.width,height: self.view.frame.height), pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        
        self.view.addSubview(pageMenu!.view)
        
        // Do any additional setup after loading the view.
        
        
        
        
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "Menu")!, centerHighlightedImage: UIImage(named: "Menu")!)
        menuButton.center = CGPoint(x: ScreenSize.width - 50, y: ScreenSize.height - 80)
        view.addSubview(menuButton)
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Settings", image: UIImage(named: "SettingsMenu")!, highlightedImage: UIImage(named: "SettingsMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.present(SettingsViewController(), animated: true, completion: nil)
        }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "Tags", image: UIImage(named: "TagsMenu")!, highlightedImage: UIImage(named: "TagsMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.present(TagsViewController(), animated: true, completion: nil)
        }
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Bookmarks", image: UIImage(named: "BookmarkMenu")!, highlightedImage: UIImage(named: "BookmarkMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.present(BookmarkViewController(), animated: true, completion: nil)
        }
        
        menuButton.enabledFoldingAnimations  = [.MenuItemFade, .MenuItemMoving]
        menuButton.allowSounds = false
        menuButton.menuItemMargin = 15
        menuButton.bottomViewAlpha = 0.7
        menuButton.addMenuItems([item1, item2, item3])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.hidesBottomBarWhenPushed = true
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
}
