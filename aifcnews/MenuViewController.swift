//
//  MenuViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 8/10/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import SideMenuController_Swift4
import SVProgressHUD

final class MenuViewController: UIViewController {

    // MARK: Properties

    private let menu = ["News", "Bookmarks", "Tags", "Settings"]

    var tags: [Tag] = [] {
        didSet {

        }
    }
    
    var initialTag: Tag?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = "000B17".hexColor
        tableView.separatorStyle = .none
        return tableView
    }()
    
    // MARK: View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
    }

    // MARK: Configure Views

    private func setupViews() {
        view.backgroundColor = "000B17".hexColor
        view.addSubview(tableView)
    }

    // MARK: Configure Constraints

    private func setupConstraints() {
        tableView.easy.layout(
            CenterX(),
            CenterY(),
            Height(Helper.shared.constrain(with: .height, num: 250)),
            Width(ScreenSize.width)
        )
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

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
        var destination: UIViewController?

        switch(indexPath.section, indexPath.row) {
        case(0, 0):
            destination = FeedViewController()
        case(0, 1):
            destination = BookmarkViewController()
        case(0, 2):
            destination = TagsViewController()
        case(0, 3):
            destination = SettingsViewController()
        default:
            break
        }

        guard let destinationVC = destination else {
            return
        }

        sideMenuController?.embed(centerViewController: UINavigationController(rootViewController: destinationVC))
        tableView.reloadData()
    }
}
