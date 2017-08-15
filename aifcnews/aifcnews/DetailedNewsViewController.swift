//
//  DetailedNewsViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/17/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import RealmSwift
import SVProgressHUD

class DetailedNewsViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: Properties
    
    var newsTitles = Set<String>()
    var data: Data? = nil
    var preCheck = 0
    var postCheck = 0
    var isFirstLoad = true
    
    var image: UIImage?
    
    var newsObject: News? {
        didSet {
            configureView()
        }
    }
    
    lazy var webView: UIWebView = {
        let webView = UIWebView()
        webView.isUserInteractionEnabled = true
        webView.scalesPageToFit = true
        return webView
    }()
    
    lazy var lowerBar: UIView = {
        let view = UIView()
        view.backgroundColor = "000B17".hexColor
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = "C8C7CC".hexColor
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LeftArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bookmark"), for: .normal)
        button.addTarget(self, action: #selector(bookmarkPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Upload")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(sharePressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        heroModalAnimationType = .selectBy(presenting: .push(direction: .left), dismissing: .push(direction: .right))
        setupNavigationBar()
        setupViews()
        setupConstraints()
        fetchSavedTitles()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if preCheck == 0 && postCheck == 1{
            saveBookmark()
        } else if preCheck ==  1 && postCheck == 0{
            removeBookmark()
        }
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newsTitles), forKey: "newsTitles")
    }
    
    // MARK: Configure Views
    
    func setupViews(){
        view.backgroundColor = "000B17".hexColor
        [webView, lowerBar, line].forEach {
            view.addSubview($0)
        }
        [backButton, bookmarkButton, shareButton].forEach{
            lowerBar.addSubview($0)
        }
        webView.delegate = self
    }
    
    
    // MARK: Configure Constraints
    
    
    func setupConstraints() {
        
        webView <- Edges()
        
        line <- [
            Width(ScreenSize.width),
            Height(1),
            Bottom(0).to(lowerBar)
        ]
        
        lowerBar <- [
            Bottom(0),
            Height(Helper.shared.constrain(with: .height, num: 50)),
            Width(ScreenSize.width)
        ]
        
        backButton <- [
            Left(Helper.shared.constrain(with: .height, num: 15)),
            CenterY(),
            Height(Helper.shared.constrain(with: .width, num: 34)),
            Width(Helper.shared.constrain(with: .width, num: 23))
        ]
        
        shareButton <- [
            Right(Helper.shared.constrain(with: .width, num: 15)),
            Top(Helper.shared.constrain(with: .height, num: 13)),
            Bottom(Helper.shared.constrain(with: .height, num: 13)),
            Width(Helper.shared.constrain(with: .width, num: 19))
        ]
        
        bookmarkButton <- [
            Right(Helper.shared.constrain(with: .width, num: 20)).to(shareButton),
            Top(Helper.shared.constrain(with: .height, num: 17)),
            Bottom(Helper.shared.constrain(with: .height, num: 13)),
            Width(Helper.shared.constrain(with: .width, num: 15))
        ]
        
    }
    
    // MARK: Configure Navigaton Bar
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: Fetch Saved Bookmarks
    
    func fetchSavedTitles(){
        if let newsTitlesObject = UserDefaults.standard.value(forKey: "newsTitles") as? NSData {
            newsTitles = NSKeyedUnarchiver.unarchiveObject(with: newsTitlesObject as Data) as! Set<String>
            checkForBookmark(newsTitles)
        }
    }
    
    // MARK: Initial check for saved bookmark
    
    func checkForBookmark(_ newsTitles: Set<String>) {
        if let title = newsObject?.title{
            if newsTitles.contains(title){
                bookmarkButton.setImage(UIImage(named: "FilledBookmark"), for: .normal)
                preCheck = 1
                postCheck = 1
            } else {
                bookmarkButton.setImage(UIImage(named: "Bookmark"), for: .normal)
            }
        }
    }

    // MARK: Function To Go Back
    
    func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: WebView Delegate Methods
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        if isFirstLoad {
            SVProgressHUD.show(withStatus: "Loading...")
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        isFirstLoad = false
        SVProgressHUD.dismiss()
    }
    
    // MARK: Bookmark DidPress Function
    
    func bookmarkPressed() {
        if bookmarkButton.imageView?.image == UIImage(named: "Bookmark"){
            bookmarkButton.setImage(UIImage(named: "FilledBookmark"), for: .normal)
            if let title = newsObject?.title{
                newsTitles.insert(title)
                postCheck = 1
            }
        } else {
            bookmarkButton.setImage(UIImage(named: "Bookmark"), for: .normal)
            if let title = newsObject?.title{
                newsTitles.remove(title)
                postCheck = 0
            }
        }
    }
    
    // MARK: Bookmark Saving Function
    
    func saveBookmark(){
        let newsToSave = RealmNews()
        if let date = newsObject?.date, let title = newsObject?.title, let link = newsObject?.link, let image = self.image {
            newsToSave.date = date
            newsToSave.link = link
            newsToSave.title = title
            if let data = UIImagePNGRepresentation(image) as NSData? {
                newsToSave.image = data
            }
        }
        try! realm.write {
            realm.add(newsToSave)
        }
    }
    
    // MARK: Bookmark Deleting Function
    
    func removeBookmark() {
        try! realm.write {
            if let title = newsObject?.title {
                guard let object = realm.objects(RealmNews.self).filter("title = %@", title).first?.title else {
                    return
                }
                realm.delete(realm.objects(RealmNews.self).filter("title = %@", object).first!)
            }
        }
    }
    
    // MARK: Function To Add Quotes To Title
    
    func addSingleQuotes(to string: String) -> String {
        var modifiedString = ""
        var counter = 0
        for char in modifiedString.characters{
            if char == "'" {
                modifiedString.append("\'")
            } else {
                modifiedString.append(char)
            }
            counter += 1
            if counter == modifiedString.characters.count{
                return modifiedString
            }
        }
        return modifiedString
    }
    
    // MARK: Update UI
    
    func configureView() {
        if let news = newsObject{
            guard let link = news.link else {
                return
            }
            let request = URLRequest(url:  URL(string: link)!)
            self.webView.loadRequest(request)
        }
    }
    
    // MARK: Share Function
    
    func sharePressed() {
        if let link = newsObject?.link
        {
            let activityVC = UIActivityViewController(activityItems: [link], applicationActivities: nil)
            activityVC.excludedActivityTypes = [.airDrop,
                                                UIActivityType(rawValue: "com.google.GooglePlus.ShareExtension"),
                                                UIActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension")]
            activityVC.popoverPresentationController?.sourceView = UIView()
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}
