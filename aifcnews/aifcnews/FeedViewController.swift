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
import RealmSwift
import BTNavigationDropdownMenu
import SVProgressHUD


protocol Communicatable {
    func fetch(with array: [Tag])
}


class FeedViewController: UIViewController, Communicatable {
    
    var news = [News]()
    
    var tags: [Tag] = [] {
        didSet{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                self.updateMenuView(with: self.tags)
            })
        }
    }
    
    var currentTag: Tag? {
        didSet {
            if let subtags = currentTag?.subtags{
                fetchData(with: subtags)
            }
        }
    }
    
    var initialTag: Tag? {
        didSet{
            if let subtags = initialTag?.subtags{
                fetchData(with: subtags)
            }
        }
    }
    
    lazy var menuView: BTNavigationDropdownMenu = {
        let menuView = BTNavigationDropdownMenu(title: "Menu", items: [])
        menuView.cellHeight = 40
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = .mainBlue
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "OpenSans-Semibold", size: 13)
        menuView.navigationBarTitleFont = UIFont(name: "OpenSans-Semibold", size: 15)
        menuView.cellTextLabelAlignment = .center // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.black
        menuView.maskBackgroundOpacity = 0.3
        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> Void in
            self.tagPressed(with: indexPath)
        }
        return menuView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 210
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "UpArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.alpha = 0
        button.isHidden = true
        button.addTarget(self, action: #selector(arrowButtonPressed), for: .touchUpInside)
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundGrey
        setupProgressView()
        setupNavigationController()
        setupViews()
        setupExpandingMenuButton()
        setupConstraints()
    }
    
    func setupProgressView(){
        SVProgressHUD.setContainerView(tableView)
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setBackgroundLayerColor(.clear)
        SVProgressHUD.show()
    }
    
    func setupNavigationController(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = .mainBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationItem.titleView = menuView
    }
    
    func setupViews(){
        view.addSubviews(tableView, arrowButton)
    }
    
    func setupExpandingMenuButton() {
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "Menu")!, centerHighlightedImage: UIImage(named: "Menu")!)
        menuButton.center = CGPoint(x: ScreenSize.width - 50, y: ScreenSize.height - 100)
        
        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Settings", image: UIImage(named: "SettingsMenu")!, highlightedImage: UIImage(named: "SettingsMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.present(SettingsViewController(), animated: true, completion: nil)
        }
        
        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "Tags", image: UIImage(named: "TagsMenu")!, highlightedImage: UIImage(named: "TagsMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            let vc = TagsViewController()
            vc.delegate = self
            self.view.window?.rootViewController?.present(vc, animated: true, completion: nil)
        }
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Bookmarks", image: UIImage(named: "BookmarkMenu")!, highlightedImage: UIImage(named: "BookmarkMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
            self.present(BookmarkViewController(), animated: true, completion: nil)
        }
        
        menuButton.enabledFoldingAnimations  = [.MenuItemFade, .MenuItemMoving]
        menuButton.allowSounds = false
        menuButton.menuItemMargin = 15
        menuButton.bottomViewAlpha = 0.7
        menuButton.addMenuItems([item1, item2, item3])
        view.addSubview(menuButton)
    }
    
    func updateMenuView(with tags: [Tag]){
        var items = [String]()
        for tag in tags{
            items.append(tag.tag)
        }
        menuView.updateItems(items)
    }
    
    
    func setupConstraints() {
        tableView <- Edges()
        
        arrowButton <- [
            Bottom(Helper.shared.constrain(with: .height, num: 12)),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Width(Helper.shared.constrain(with: .width, num: 62)),
            Height(Helper.shared.constrain(with: .height, num: 64))
        ]
        
    }
    
    func fetch(with array: [Tag]) {
        tags = array
        updateMenuView(with: array)
    }
    
    func fetchData(with subtags: [Subtag]) {
        News.fetchNews(with: subtags) { (data, error) in
            if let data = data {
                self.news = data
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                    SVProgressHUD.dismiss()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func tagPressed(with index: Int) {
        currentTag = tags[index]
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
        arrowButton.alpha = 0
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
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.selectionStyle = .none
        cell.newsObject = news[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FeedTableViewCell
        let image = cell.backgroundImageView.image
        let vc = DetailedNewsViewController()
        vc.image = image
        vc.newsObject = news[(tableView.indexPathForSelectedRow?.row)!]
        present(vc, animated: true, completion: nil)
    }
}
