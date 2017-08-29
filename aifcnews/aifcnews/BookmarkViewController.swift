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
    var newsTitles = Set<String>()
    
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
        fetchBookmarks()
        setupGestures()
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
    
    // MARK: Fetch Saved Bookmarks
    
    func fetchBookmarks(){
        if let newsTitlesObject = UserDefaults.standard.value(forKey: "newsTitles") as? NSData {
            self.newsTitles = NSKeyedUnarchiver.unarchiveObject(with: newsTitlesObject as Data) as! Set<String>
        }
    }
    
    func setupGestures(){
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(sender:)))
        tableView.addGestureRecognizer(longPress)
    }
    
    func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state == UIGestureRecognizerState.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                if let link = news[indexPath.row].link, let title = news[indexPath.row].title {
                    showAlert(with: title, and: link, and: indexPath.row)
                }
            }
        }
    }
    
    func showAlert(with title: String, and link: String, and index: Int) {
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Open in Safari", style: .default, handler: { (UIAlertAction) in
            UIApplication.shared.openURL(URL(string: link)!)
        }))
        actionSheet.addAction(UIAlertAction(title: "Share", style: .default, handler: { (UIAlertAction) in
            self.share(with: link)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Remove Bookmark", style: .default, handler: { (UIAlertAction) in
            self.removeBookmark(where: title)
            self.news.remove(at: index)
            self.tableView.reloadData()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    func share(with link: String) {
        let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
        activityVC.excludedActivityTypes = [.airDrop,
                                            UIActivityType(rawValue: "com.google.GooglePlus.ShareExtension"),
                                            UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension")]
        activityVC.popoverPresentationController?.sourceView = UIView()
        self.present(activityVC, animated: true, completion: nil)
    }
    
    // MARK: Bookmark Deleting Function
    
    func removeBookmark(where title: String) {
        try! realm.write {
            guard let object = realm.objects(RealmNews.self).filter("title = %@", title).first?.title else {
                return
            }
            realm.delete(realm.objects(RealmNews.self).filter("title = %@", object).first!)
            newsTitles.remove(title)
            saveBookmarkTitles()
        }
    }
    
    func saveBookmarkTitles(){
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newsTitles), forKey: "newsTitles")
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
        print("indexpath", indexPath.row)
        cell.newsObject = news[indexPath.row] as News
        cell.newsImageView.image = news[indexPath.row].image
        cell.selectionStyle = .none
        return cell
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
