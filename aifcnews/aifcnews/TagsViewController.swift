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
        fetchSelectedTags()
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isStatusBarHidden = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        let selectedTags = AppDelegate.transform(selectedSubtags: selectedSubtags)
        self.delegate?.fetch(with: selectedTags)
    }
    
    func setupNavigationBar() {
        let screenSize: CGRect = UIScreen.main.bounds
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 65))
        let navItem = UINavigationItem(title: "Tags");
        navBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.mainBlue]
        navBar.setItems([navItem], animated: true)
        navBar.barStyle = .default
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
            Top(Helper.shared.constrain(with: .height, num: 66)),
            Bottom(0),
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
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            UIView.animate(withDuration: 0.3, animations: {
                self.line.alpha = 0
                self.lowerBar.alpha = 0
            })
        }
        else{
            UIView.animate(withDuration: 0.3, animations: {
                self.line.alpha = 1
                self.lowerBar.alpha = 1
            })
        }
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
