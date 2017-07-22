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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
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
        button.setImage(UIImage(named: "Cross")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        setupConstraints()
        fetchTags()
        // Do any additional setup after loading the view.
    }
    
    func setupNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 45))
        navBar.barTintColor = "2E4057".hexColor
        let navItem = UINavigationItem(title: "Tags");
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navBar.setItems([navItem], animated: true);
        self.view.addSubview(navBar)
    }

    func setupViews(){
        [tableView, lowerBar, line].forEach {
            view.addSubview($0)
        }
        lowerBar.addSubview(dismissButton)
    }
    
    func setupConstraints() {
        
        tableView <- [
            Top(Helper.shared.constrain(with: .height, num: 40)),
            Bottom(Helper.shared.constrain(with: .height, num: 50)),
            Width(ScreenSize.width)
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
    
    func fetchTags() {
        tags = Tag.fetchTags()
        tableView.reloadData()
    }

    
    func dismissButtonPressed() {
        dismiss(animated: true, completion: nil)
    }

}



extension TagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tags[section].collapsed ? 0 : tags[section].subtags.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? CollapsibleTableViewHeader ?? CollapsibleTableViewHeader(reuseIdentifier: "header")
        
        header.tagObject = tags[section]
        header.setCollapsed(tags[section].collapsed)
        
        header.section = section
        header.delegate = self
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TagsTableViewCell
        cell.selectionStyle = .none
        cell.subtag = tags[indexPath.section].subtags[indexPath.row]
        cell.circleView.backgroundColor = tags[indexPath.section].color
        
        if cell.isSelected{
            cell.isSelected(true)
        } else {
            cell.isSelected(false)
        }
        return cell
    }
    
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tags[(indexPath as NSIndexPath).section].collapsed ? 0 : UITableViewAutomaticDimension
    }
    
     func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TagsTableViewCell
        cell.isSelected(true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TagsTableViewCell
         cell.isSelected(false)
    }
}

extension TagsViewController: CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int) {
        let collapsed = !tags[section].collapsed
        
        // Toggle collapse
        tags[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        // Reload the whole section
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
}
