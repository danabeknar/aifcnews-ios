//
//  BookmarkViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/23/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

class BookmarkViewController: UIViewController {

    var news = [News]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.layer.borderWidth = 0
        tableView.separatorStyle = .none
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = "000B17".hexColor
        setupViews()
        setupConstraints()
        setupNavigationBar()
        fetchRealmNews()
    }
    
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRealmNews()
    }
    
    func setupViews(){
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView <- [
            Top(0),
            Width(ScreenSize.width),
            Bottom(0)
        ]
    }

    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = "0A1520".hexColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "SFProDisplay-Regular", size: 18)!]
        self.navigationController?.navigationBar.topItem?.title = "Bookmarks"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.line.alpha = 0
//                self.lowerBar.alpha = 0
//            })
//        }
//        else{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.line.alpha = 1
//                self.lowerBar.alpha = 1
//            })
//        }
        }
    }

    func fetchRealmNews(){
        self.news.removeAll()
        Database.shared.fetchRealmNews { (news) in
            if news != nil {
                self.news = news!
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                print("News are empty")
            }
        }
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        cell.newsObject = news[indexPath.row] as News
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 209
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! FeedTableViewCell
//        let image = cell.newsImageView.image
//        let vc = DetailedNewsViewController()
//        vc.image = image
//        vc.newsObject = news[(tableView.indexPathForSelectedRow?.row)!]
//        present(vc, animated: true, completion: nil)
    }
    
}
