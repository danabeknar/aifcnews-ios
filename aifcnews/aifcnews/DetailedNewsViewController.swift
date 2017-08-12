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

class DetailedNewsViewController: UIViewController {
    
    var newsTitles = Set<String>()
    var data: Data? = nil
    var preCheck = 0
    var postCheck = 0
    
    
    var newsObject: News? {
        didSet {
            configureView()
        }
    }
    
    lazy var webView: UIWebView = {
        let webView = UIWebView()
        return webView
    }()
    
    lazy var lowerBar: UIView = {
        let view = UIView()
        view.backgroundColor = "000B17".hexColor
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .lineGrey
        return view
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LeftArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bookmark"), for: .normal)
        button.imageView?.tintColor = .mainBlue
        button.addTarget(self, action: #selector(bookmarkPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Upload")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(sharePressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let newsTitlesObject = UserDefaults.standard.value(forKey: "newsTitles") as? NSData {
            self.newsTitles = NSKeyedUnarchiver.unarchiveObject(with: newsTitlesObject as Data) as! Set<String>
            checkForBookmark(newsTitles)
        }
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        view.backgroundColor = "000B17".hexColor
        setupViews()
        setupConstraints()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isStatusBarHidden = false
        if preCheck == 0 && postCheck == 1{
            saveBookmark()
        } else if preCheck ==  1 && postCheck == 0{
            removeBookmark()
        }
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: newsTitles), forKey: "newsTitles")
    }
    
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
    
    func setupViews(){
        [webView, lowerBar, line].forEach {
            view.addSubview($0)
        }
        [backButton, bookmarkButton, shareButton].forEach{
            lowerBar.addSubview($0)
        }
    }
    
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
            Height(Helper.shared.constrain(with: .width, num: 24)),
            Width(Helper.shared.constrain(with: .width, num: 13))
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
    
    func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
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
    
    func saveBookmark(){
        let newsToSave = RealmNews()
        if let date = newsObject?.date, let title = newsObject?.title, let link = newsObject?.link{
            newsToSave.date = date
            newsToSave.link = link
            newsToSave.title = title
        }
        try! realm.write {
            realm.add(newsToSave)
        }
    }
    
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func configureView() {
        if let news = newsObject{
            guard let link = news.link else {
                return
            }
            print(link)
            let request = URLRequest(url:  URL(string: link)!)
            self.webView.loadRequest(request)
        }
    }
}
