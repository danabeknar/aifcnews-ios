//
//  TagsViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/18/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

class TagsViewController: UIViewController {
    
    // MARK: Properties
    
    var selectedCells = [UITableViewCell]()
    var tags = [Tag]()
    var tagsArray: [[Tag]] = []
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = true
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.1)
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0)
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        setupNavigationBar()
        fetchSelectedTags()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveSelectedTags()
    }
    
    // MARK: Configure Views
    
    func setupViews(){
        view.backgroundColor = "000B17".hexColor
        view.addSubview(tableView)
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
        tableView <- [
            Top(0),
            Bottom(0),
            Width(ScreenSize.width)
        ]
    }
    
    // MARK: Configure Navigaton Bar
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = "0A1520".hexColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "SFProDisplay-Regular", size: 18)!]
        self.navigationController?.navigationBar.topItem?.title = "Tags"
    }
    
    // MARK: Fetch Tags
    
    func fetchSelectedTags() {
        if let data = UserDefaults.standard.object(forKey: "tags") as? Data,
            let tags = NSKeyedUnarchiver.unarchiveObject(with: data) as? [[Tag]] {
            self.tagsArray = tags
        } else {
            tags = Tag.fetchTags()
            self.tagsArray.append(tags)
            self.tagsArray.append([])
        }
        tableView.reloadData()
    }
    
    // MARK: Save Selected Tags
    
    func saveSelectedTags() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: tagsArray)
        UserDefaults.standard.set(encodedData, forKey: "tags")
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension TagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0{
            return "At least 1 tag must be included"
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1{
            return "Tags not included"
        }
        return ""
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TagsTableViewCell
        cell.backgroundColor = "000B17".hexColor
        cell.selectionStyle = .none
        cell.tagObject = tagsArray[indexPath.section][indexPath.row] 
        
        cell.tagAction = { currentCell in
            if indexPath.section == 0{
                if self.tagsArray[0].count != 1{
                    let removedItem = self.tagsArray[indexPath.section].remove(at: indexPath.row)
                    self.tagsArray[indexPath.section + 1].append(removedItem)
                }
            } else {
                let removedItem = self.tagsArray[indexPath.section].remove(at: indexPath.row)
                self.tagsArray[indexPath.section - 1].append(removedItem)
            }
            self.saveSelectedTags()
            tableView.reloadData()
        }
        
        if indexPath.section == 0{
            cell.signButton.setImage(UIImage(named: "minusSign"), for: .normal)
        } else if indexPath.section == 1 {
            cell.signButton.setImage(UIImage(named: "plusSign"), for: .normal)
        }

        return cell
    }
    
}

