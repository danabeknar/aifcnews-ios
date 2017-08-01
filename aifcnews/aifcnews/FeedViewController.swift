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
import PageMenu

class FeedViewController: UIViewController {
    
    var news = [News]()
    var pageMenu : CAPSPageMenu?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setupViews()
        setupConstraints()
        fetchData()
    }
 
    
    func setupViews(){
        [tableView, arrowButton].forEach {
            view.addSubview($0)
        }
//        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
//        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPoint.zero, size: menuButtonSize), centerImage: UIImage(named: "Menu")!, centerHighlightedImage: UIImage(named: "Menu")!)
//        menuButton.center = CGPoint(x: ScreenSize.width - 50, y: ScreenSize.height - 80)
//        view.addSubview(menuButton)
//        
//        let item1 = ExpandingMenuItem(size: menuButtonSize, title: "Settings", image: UIImage(named: "SettingsMenu")!, highlightedImage: UIImage(named: "SettingsMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
//            self.present(SettingsViewController(), animated: true, completion: nil)
//        }
//        
//        let item2 = ExpandingMenuItem(size: menuButtonSize, title: "Tags", image: UIImage(named: "TagsMenu")!, highlightedImage: UIImage(named: "TagsMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
//            self.navigationController?.pushViewController(TagsViewController(), animated: true)
//        }
//        
//        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Bookmarks", image: UIImage(named: "BookmarkMenu")!, highlightedImage: UIImage(named: "BookmarkMenu")!, backgroundImage: nil, backgroundHighlightedImage: nil) { () -> Void in
//            self.present(BookmarkViewController(), animated: true, completion: nil)
//        }
//        
//        menuButton.enabledFoldingAnimations  = [.MenuItemFade, .MenuItemMoving]
//        menuButton.allowSounds = false
//        menuButton.menuItemMargin = 15
//        menuButton.bottomViewAlpha = 0.7
//        menuButton.addMenuItems([item1, item2, item3])
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
    
    func fetchData() {
        News.fetchNews { (data, error) in
            if let data = data{
                self.news = data
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            } else {
                print(error?.localizedDescription)
            }
        }
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
        cell.newsObject = news[indexPath.row] as News
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FeedTableViewCell
        let image = cell.backgroundImageView.image
        let vc = DetailedNewsViewController()
        vc.image = image
        vc.newsObject = news[(tableView.indexPathForSelectedRow?.row)!]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
