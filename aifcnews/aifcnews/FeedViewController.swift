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
import PageMenu

class FeedViewController: UIViewController {
    
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
        view.backgroundColor = .backgroundGrey
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews(){
        [tableView, arrowButton].forEach {
            view.addSubview($0)
        }
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
    
    func setupConstraints() {
        tableView <- [
            Top(0),
            Width(ScreenSize.width),
            Bottom(0)
        ]
        
        arrowButton <- [
            Bottom(Helper.shared.constrain(with: .height, num: 12)),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Width(Helper.shared.constrain(with: .width, num: 62)),
            Height(Helper.shared.constrain(with: .height, num: 64))
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.arrowButton.alpha = 0
            })
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.arrowButton.alpha = 1
            })
        }
    }
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
        return (tableView.height - 20) / 3
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(DetailedNewsViewController(), animated: true, completion: nil)
    }
    
}

//self.option.fontSize = 10
//self.option.hidesTopViewOnSwipeType = .tabBar
//self.option.isTranslucent = false
//self.option.currentColor = .white
//self.option.defaultColor = .textGrey
//self.option.tabHeight = 40
//self.option.tabBackgroundColor = .mainBlue
//self.option.highlightFontName = "OpenSans-Semibold"
//self.option.unHighlightFontName = "OpenSans-Semibold"
//self.displayControllerWithIndex(1, direction: .forward, animated: true)
