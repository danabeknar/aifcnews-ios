//
//  ViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/13/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import RealmSwift
import BTNavigationDropdownMenu
import DZNEmptyDataSet
import ReachabilitySwift
import SVProgressHUD
import SwiftWebVC
import XLActionController

class FeedViewController: UIViewController {
    
    let reachability = Reachability()!
    
    var news = [News]()
    var lastSelectedIndex = 0
    var newsTitles = Set<String>()
    
    var tags: [Tag] = []
    
    var currentTag: Tag? {
        didSet {
            if let tag = currentTag {
                fetchData(with: tag)
            }
        }
    }
    
    var initialTag: Tag?
    
    lazy var menuView: BTNavigationDropdownMenu = {
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: (self.navigationController?.view!)!, title: BTTitle.title("Menu"), items: [])
        menuView.cellHeight = 40
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = .clear
        menuView.cellSeparatorColor = .clear
        menuView.shouldKeepSelectedCellColor = true
        menuView.cellTextLabelColor = UIColor.white
        menuView.cellTextLabelFont = UIFont(name: "SFProDisplay-Regular", size: 18)
        menuView.navigationBarTitleFont = UIFont(name: "SFProDisplay-Regular", size: 18)
        menuView.selectedCellTextLabelColor = "AF3229".hexColor
        menuView.cellTextLabelAlignment = .center
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
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = "000B17".hexColor
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
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
        view.backgroundColor = "000B17".hexColor
        setupNavigationController()
        setupViews()
        setupConstraints()
        reloadTags()
        fetchBookmarks()
        parseData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTags()
        fetchBookmarks()
        parseData()
        tableView.reloadData()
    }
    
    func reloadTags() {
        tags = AppDelegate.fetchTags()
        initialTag = tags.first!
        updateMenuView(with: tags)
    }

    func setupNavigationController(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = "0A1520".hexColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func setupViews(){
        [tableView,arrowButton].forEach {
            view.addSubview($0)
        }
        navigationItem.titleView = menuView
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
    
    func fetchBookmarks(){
        if let newsTitlesObject = UserDefaults.standard.value(forKey: "newsTitles") as? NSData {
            self.newsTitles = NSKeyedUnarchiver.unarchiveObject(with: newsTitlesObject as Data) as! Set<String>
        }
    }
    
    func parseData() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkConnectivity),name: ReachabilityChangedNotification,object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    func checkConnectivity(){
        if (reachability.isReachable) {
            SVProgressHUD.show(withStatus: "Loading...")
            if let tag = initialTag{
                fetchData(with: tag)
            }
        } else {
            print("Network not reachable")
        }
    }
    
    func fetchData(with tag: Tag) {
        News.fetchNews(with: tag) { (data, error) in
            if let data = data {
                self.news = data
            }
            DispatchQueue.main.async{
                SVProgressHUD.dismiss()
                self.tableView.reloadData()
            }
        }
    }
    
    func tagPressed(with index: Int) {
        SVProgressHUD.show(withStatus: "Loading...")
        lastSelectedIndex = index
        currentTag = tags[index]
    }
    
    func arrowButtonPressed() {
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate

extension FeedViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.selectionStyle = .none
        cell.newsObject = news[indexPath.row]
        
        if let title = news[indexPath.row].title{
            if newsTitles.contains(title) {
                cell.showBookmark()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc = DetailedNewsViewController()
            vc.newsObject = news[indexPath.row]
            self.present(vc, animated: true, completion: nil)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "nodata")
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 1
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        if (reachability.isReachable){
            return false
        } else {
            return true
        }
    }
}
