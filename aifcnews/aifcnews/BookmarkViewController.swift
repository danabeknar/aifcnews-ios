//
//  BookmarkViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/23/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import DZNEmptyDataSet
import SVProgressHUD
import ReachabilitySwift

class BookmarkViewController: UIViewController {

    // MARK: Properties
    
    var news = [News]()
    let reachability = Reachability()!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.backgroundColor = .clear
        tableView.layer.borderWidth = 0
        tableView.separatorStyle = .none
        tableView.rowHeight = 120
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = "000B17".hexColor
        setupViews()
        setupConstraints()
        setupNavigationBar()
        fetchRealmNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealmNews()
    }
    
    // MARK: Configure Views
    
    func setupViews(){
        view.addSubview(tableView)
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
        tableView <- [
            Top(0),
            Width(ScreenSize.width),
            Bottom(0)
        ]
    }
    
    // MARK: Configure Navigaton Bar

    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = "0A1520".hexColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "SFProDisplay-Regular", size: 18)!]
        self.navigationController?.navigationBar.topItem?.title = "Bookmarks"
    }
    
    // MARK: Fetch Data

    func fetchRealmNews(){
        self.news.removeAll()
        self.tableView.reloadData()
        Database.shared.fetchRealmNews { (news) in
            if news != nil {
                self.news = news!
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataDelegate

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.newsObject = news[indexPath.row] as News
        cell.selectionStyle = .none
        cell.showBookmark()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailedNewsViewController()
        vc.newsObject = news[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "notAvailable")
    }
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 1
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }

}
