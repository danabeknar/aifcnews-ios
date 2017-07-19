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
    var color: UIColor?
}

class SettingsViewController: UIViewController {

    var sectionItems = [
        [SettingsItem(image: UIImage(named: "Star")!, title: "Rate Us", color: "007AFF".hexColor),
         SettingsItem(image: UIImage(named: "Share")!, title: "Share With Friends", color: "FF9500".hexColor),
         SettingsItem(image: UIImage(named: "Message")!, title: "Contact Us", color: "4CD964".hexColor)],
        [SettingsItem(image: UIImage(named: "Ring")!, title: "Enable Notifications", color: "5856D6".hexColor) ]
    ]
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = Helper.shared.constrain(with: .height, num: 45)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
            label.textColor = "9B9B9B".hexColor
            label.textAlignment = .center
            label.numberOfLines = 0
            label.text = "Made with ❤️ \n Version 1.0"
            label.font = UIFont(name: "OpenSans-Light", size: Helper.shared.constrain(with: .height, num: 15))
        return label
    }()
    
    
    lazy var lowerBar: UIView = {
        let view = UIView()
        view.backgroundColor = .barGrey
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.backgroundColor = .lineGrey
        return view
    }()
    
    lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Letter-x")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        
//        self.option.fontSize = 14
//        self.option.isTranslucent = false
//        self.option.currentColor = .mainBlue
//        self.option.defaultColor = .textGrey
//        self.option.tabHeight = 40
//        self.option.tabBackgroundColor = .white
//        self.option.highlightFontName = "OpenSans-Semibold"
//        self.option.unHighlightFontName = "OpenSans-Semibold"
    }
    
    func setupViews() {
        view.addSubviews(tableView, lowerBar, line)
        lowerBar.addSubview(dismissButton)
        tableView.tableFooterView = infoLabel
        infoLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
    }
    
    func setupConstraints() {
        tableView <- [
            Top(Helper.shared.constrain(with: .height, num: 65)),
            Width(ScreenSize.width),
            Bottom(0).to(line)
        ]
        
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
        
        dismissButton <- [
            Height(Helper.shared.constrain(with: .height, num: 18)),
            Width(Helper.shared.constrain(with: .width, num: 18)),
            CenterY(),
            CenterX()
        ]
    }
    
    func dismissButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
}


extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionItems[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SettingsTableViewCell
        let section = sectionItems[indexPath.section][indexPath.row]
        cell.cellObject = section
        
        if indexPath.section == 1 && indexPath.row == 0{
            cell.addSwitch()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Support Us"
        }
        return "Notifications"
    }

}
