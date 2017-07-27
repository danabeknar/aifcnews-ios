//
//  ViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/13/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import ExpandingMenu
import Sugar
import TabPageViewController

class FeedViewController: TabPageViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    

    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "UpArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.alpha = 0
        button.addTarget(self, action: #selector(arrowButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let vc1 = FeedViewController()
        let vc2 = FeedViewController()
        
        self.tabItems = [(vc1, "First"), (vc2, "Second")]
        
        self.option.fontSize = 10
        self.option.hidesTopViewOnSwipeType = .tabBar
        self.option.isTranslucent = false
        self.option.currentColor = .white
        self.option.defaultColor = .textGrey
        self.option.tabHeight = 40
        self.option.tabBackgroundColor = .mainBlue
        self.option.highlightFontName = "OpenSans-Semibold"
        self.option.unHighlightFontName = "OpenSans-Semibold"
        self.displayControllerWithIndex(0, direction: .forward, animated: true)
        
        setupViews()
        setupConstraints()
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    
    func setupViews(){
        [tableView, arrowButton].forEach {
            view.addSubview($0)
        }
        
        let menuButtonSize: CGSize = CGSize(width: 54.0, height: 54.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "Menu")!, centerHighlightedImage: UIImage(named: "Menu")!)
        menuButton.center = CGPoint(x: self.view.bounds.width - Helper.shared.constrain(with: .width, num: 50), y: self.view.bounds.height - Helper.shared.constrain(with: .height, num: 50))
        view.addSubview(menuButton)
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Settings", image: UIImage(named: "settingsMenu")!, highlightedImage: UIImage(named: "settingsMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.present(SettingsViewController(), animated: true, completion: nil)
        }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "Tags", image: UIImage(named: "tagsMenu")!, highlightedImage: UIImage(named: "tagsMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.present(TagsViewController(), animated: true, completion: nil)
        }
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Bookmarks", image: UIImage(named: "bookmarkMenu")!, highlightedImage: UIImage(named: "bookmarkMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.present(BookmarkViewController(), animated: true, completion: nil)
        }
        
        menuButton.enabledFoldingAnimations  = [.MenuItemFade, .MenuItemMoving]
        menuButton.allowSounds = false
        menuButton.menuItemMargin = 15
        menuButton.bottomViewAlpha = 0.7
        menuButton.addMenuItems([item1, item2, item3])
    }
    
    func setupConstraints() {        
        tableView <- [
            Top(Helper.shared.constrain(with: .width, num: 40)),
            Width(ScreenSize.width),
            Height(Helper.shared.constrain(with: .height, num: 627))
        ]
        
        arrowButton <- [
            Bottom(Helper.shared.constrain(with: .height, num: 20)),
            Left(Helper.shared.constrain(with: .width, num: 15)),
            Width(Helper.shared.constrain(with: .width, num: 52)),
            Height(Helper.shared.constrain(with: .height, num: 52))
        ]

    }
    
    func arrowButtonPressed() {
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
//    override open func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.arrowButton.alpha = 0
//            })
//        }
//        else{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.arrowButton.alpha = 1
//            })
//        }
//    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 3
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(DetailedNewsViewController(), animated: true, completion: nil)
    }
    
}
