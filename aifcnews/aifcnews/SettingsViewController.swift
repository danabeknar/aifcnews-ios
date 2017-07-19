//
//  SettingsViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/18/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import TabPageViewController

struct SettingsItem {
    var image: UIImage?
    var title: String?
}

class SettingsViewController: TabPageViewController {

//    lazy var tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.isScrollEnabled = false
//        tableView.backgroundColor = .clear
//        tableView.rowHeight = Helper.shared.constrain(with: .height, num: 45)
//        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: "Cell")
//        return tableView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        self.option.fontSize = 14
        self.option.isTranslucent = false
        self.option.currentColor = .mainBlue
        self.option.defaultColor = .textGrey
        self.option.tabHeight = 40
        self.option.tabBackgroundColor = .white
        self.option.highlightFontName = "OpenSans-Semibold"
        self.option.unHighlightFontName = "OpenSans-Semibold"
    }
    
    func setupViews() {
        
    }
    
    func setupConstraints() {
        
    }
    
}

