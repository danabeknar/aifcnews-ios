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
    var selectedSubtags = [Subtag]()
    var delegate: Communicatable?
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.backgroundColor = .clear
        tableView.allowsMultipleSelection = true
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupViews()
        setupConstraints()
        fetchTags()
        fetchSelectedTags()
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        let selectedTags = AppDelegate.transform(selectedSubtags: selectedSubtags)
        self.delegate?.fetch(with: selectedTags)
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
    
    func fetchTags() {
        tags = Tag.fetchTags()
    }
    
    func fetchSelectedTags() {
        if let data = UserDefaults.standard.object(forKey: "tags") as? Data,
            let subtags = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Subtag] {
            self.selectedSubtags = subtags
        }
        tableView.reloadData()
    }
    
    func saveSelectedTags() {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: selectedSubtags)
        UserDefaults.standard.set(encodedData, forKey: "tags")
    }
    
    func dismissButtonPressed() {
        dismiss(animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.line.alpha = 0
//                self.lowerBar.alpha = 0
//            })
//        }
//        else{
//            UIView.animate(withDuration: 0.3, animations: {
//                self.line.alpha = 1
//                self.lowerBar.alpha = 1
//            })
//        }
    }
    
}



extension TagsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return tags[section].subtags.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tags[section].tag
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TagsTableViewCell
        cell.selectionStyle = .none
        cell.subtag = tags[indexPath.section].subtags[indexPath.row]
        cell.cellTag = tags[indexPath.section].tag
        cell.circleView.backgroundColor = tags[indexPath.section].color
        
        let selectedSubtagsTexts = selectedSubtags.flatMap{ $0.subtag }
        
        if !selectedSubtags.isEmpty {
            cell.isChosen = selectedSubtagsTexts.contains(tags[indexPath.section].subtags[indexPath.row].subtag)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TagsTableViewCell
        if cell.isChosen {
            for i in 0..<selectedSubtags.count {
                if selectedSubtags[i].subtag == tags[indexPath.section].subtags[indexPath.row].subtag {
                    selectedSubtags.remove(at: i)
                    break
                }
            }
        } else {
            selectedSubtags.append(tags[indexPath.section].subtags[indexPath.row])
        }
        if selectedSubtags.isEmpty { cell.isChosen = false }
        saveSelectedTags()
        tableView.reloadData()
    }
    
}
