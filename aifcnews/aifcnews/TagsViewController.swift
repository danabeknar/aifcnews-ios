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
    
    var selectedCells = [UITableViewCell]()
    var tags = [Tag]()
    var tagsArray: [[Tag]] = []
    var sections = ["Tags Included", "Tags Not Included"]
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = "000B17".hexColor
        tableView.allowsMultipleSelection = true
        tableView.separatorColor = UIColor(white: 1.0, alpha: 0.1)
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = "000B17".hexColor
        setupNavigationBar()
        setupViews()
        setupConstraints()
        fetchSelectedTags()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        saveSelectedTags()
    }
    
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = "0A1520".hexColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "SFProDisplay-Regular", size: 18)!]
        self.navigationController?.navigationBar.topItem?.title = "Tags"
    }
    
    func setupViews(){
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView <- [
            Top(0),
            Bottom(0),
            Width(ScreenSize.width)
        ]
    }
    
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
    
    func saveSelectedTags() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: tagsArray)
        UserDefaults.standard.set(encodedData, forKey: "tags")
    }
}



extension TagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsArray[section].count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "SFProDisplay-Regular", size: 18)
        header.textLabel?.textColor = "989CA6".hexColor
        let tableViewHeaderFooterView: UITableViewHeaderFooterView? = header
        tableViewHeaderFooterView?.textLabel?.text = tableViewHeaderFooterView?.textLabel?.text?.capitalized
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TagsTableViewCell
        cell.backgroundColor = "000B17".hexColor
        cell.selectionStyle = .none
        cell.tagObject = tagsArray[indexPath.section][indexPath.row] 
        
        cell.tagAction = { currentCell in
            if indexPath.section == 0{
                let removedItem = self.tagsArray[indexPath.section].remove(at: indexPath.row)
                self.tagsArray[indexPath.section + 1].append(removedItem)
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

