////
////  BaseViewController.swift
////
////
////  Created by Beknar Danabek on 7/27/17.
////
////
//
//import UIKit
//import ExpandingMenu
//
//class BaseViewController: UIViewController, CAPSPageMenuDelegate{
//    
//    var pageMenu : CAPSPageMenu?
//    var tags = [Tag]()
//    var controllersArray : [UIViewController] = []
//    
//    var recognizer: Bool? {
//        didSet{
//            for view in view.subviews{
//                view.removeFromSuperview()
//            }
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupPageMenu()
//        setupExpandingMenuButton()
//    }
//    
//    func willMoveToPage(_ controller: UIViewController, index: Int) {
//        let vc = controller as! FeedViewController
//        vc.currentSubtags = tags[index].subtags
//    }
//    
//    func setupPageMenu() {
//        let parameters: [CAPSPageMenuOption] = [
//            .viewBackgroundColor(.backgroundGrey),
//            .scrollMenuBackgroundColor(.mainBlue),
//            .selectedMenuItemLabelColor(.white),
//            .unselectedMenuItemLabelColor(.lightGray),
//            .menuItemSeparatorColor(.white),
//            .selectionIndicatorHeight(1),
//            .menuItemFont(UIFont(name: "OpenSans-Semibold", size: 11)!),
//            .menuItemWidthBasedOnTitleTextWidth(true),
//            .menuItemSeparatorRoundEdges(true),
//            .enableHorizontalBounce(true),
//            .menuMargin(50),
//            .addBottomMenuHairline(true)
//    ]
//    
//        for i in tags {
//            let vc = FeedViewController()
//            vc.title = i.tag
//            controllersArray.append(vc)
//        }
//        
//        pageMenu = CAPSPageMenu(viewControllers: controllersArray, frame: CGRect(x:0.0,y: 0.0,width: self.view.frame.width,height: self.view.frame.height), pageMenuOptions: parameters)
//        pageMenu?.currentPageIndex = 1
//        pageMenu?.delegate = self
//    
//        if let pageView = pageMenu?.view{
//            self.view.addSubview(pageView)
//        }
//    }
//    
//    
//}
