//
//  MenuViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 8/10/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import SideMenuController
import SVProgressHUD

class MenuViewController: UIViewController {
    
    let menu = ["Newsroom", "Bookmarks", "Tags", "Settings"]
    
    var tags: [Tag] = [] {
        didSet{
            
        }
    }
    
    var initialTag: Tag?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = "000B17".hexColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewStyle()
        setupViews()
        setupConstraints()
    }
    
    func setupViewStyle(){
        view.backgroundColor = "000B17".hexColor
    }
    
    func setupViews(){
        view.addSubview(tableView)
    }
    
    func setupConstraints(){
        tableView <- [
            CenterX(),
            CenterY(),
            Height(Helper.shared.constrain(with: .height, num: 250)),
            Width(ScreenSize.width)
        ]
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuTableViewCell
        cell.titleLabel.text = menu[indexPath.row]
        cell.selectionStyle = .none
        if let lastPressedCellIndex = UserDefaults.standard.object(forKey: "lastPressedCell") as? Int {
            if lastPressedCellIndex == indexPath.row {
                cell.titleLabel.textColor = "AF3229".hexColor
            } else {
                cell.titleLabel.textColor = .white
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "lastPressedCell")
        var destination: UIViewController? = nil

        switch(indexPath.section, indexPath.row){
        case(0,0):
            destination = FeedViewController()
        case(0,1):
            destination = BookmarkViewController()
        case(0,2):
            destination = TagsViewController()
        case(0,3):
            destination = SettingsViewController()
        default: break
        }
        
        guard let destinationVC = destination else {
            print("Switch didn't work out...")
            return
        }

        sideMenuController?.embed(centerViewController: UINavigationController(rootViewController: destinationVC))
        tableView.reloadData()
    }
}
