//
//  SettingsViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/18/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import SwiftWebVC

struct Settings{
    var title: String
    var items: [SettingsItem]
}

struct SettingsItem {
    var title: String
}

// MARK: Properties

class SettingsViewController: UIViewController {

    var sectionItems = [
        Settings(title: "SUPPORT US", items: [SettingsItem(title: "Rate Us"),SettingsItem(title: "Share With Friends"), SettingsItem(title: "Contact Us")]),
        Settings(title: "ABOUT APPLICATION", items: [SettingsItem(title: "Version"), SettingsItem(title: "Visit AIFC Website")])
    ]
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.backgroundColor = "000B17".hexColor
        tableView.rowHeight = Helper.shared.constrain(with: .height, num: 45)
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.1)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()
    }
    
    // MARK: Configure Views

    func setupViews() {
        view.backgroundColor = "000B17".hexColor
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
        self.navigationController?.navigationBar.topItem?.title = "Settings"
    }

    
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionItems[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionItems[section].title
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SettingsTableViewCell
        cell.backgroundColor = "000B17".hexColor
        cell.titleLabel.text = sectionItems[indexPath.section].items[indexPath.row].title
        switch (indexPath.section, indexPath.row){
        case (0, 0...2): cell.accessoryType = .disclosureIndicator
        case (1, 0): cell.addLabel()
        case (1, 1): cell.accessoryType = .disclosureIndicator
        default: break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch (indexPath.section, indexPath.row) {
        case (0, 0): ShareManager.shared.appStoreRate()
        case (0, 1): ShareManager.shared.share(at: self)
        case (0, 2): ShareManager.shared.mailFeedback(at: self)
        case (1, 1): let webVC = SwiftModalWebVC(urlString: "http://www.aifc.kz", theme: .lightBlack, dismissButtonStyle: .arrow)
                     self.present(webVC, animated: true, completion: nil)
        default: break
        }
    }

}
