//
//  ViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/13/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import ExpandingMenu
import TabPageViewController
import Sugar

class FeedViewController: UIViewController {


    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    lazy var arrowButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Arrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7)
        button.backgroundColor = .white
        button.layer.cornerRadius = Helper.shared.constrain(with: .height, num: Int(16))
        button.addTarget(self, action: #selector(arrowButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var menuButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Menu")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(11, 8, 11, 8)
        button.backgroundColor = .mainBlue
        button.layer.cornerRadius = Helper.shared.constrain(with: .height, num: Int(16))
        button.addTarget(self, action: #selector(menuPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroundGrey
        setupViews()
        setupConstraints()
        
    }

    
    func setupViews(){
        [tableView, arrowButton, menuButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setupConstraints() {        
        tableView <- [
            Top(Helper.shared.constrain(with: .width, num: 40)),
            Width(ScreenSize.width),
            Height(Helper.shared.constrain(with: .height, num: 627))
        ]
        
        arrowButton <- [
            Bottom(Helper.shared.constrain(with: .height, num: 20)),
            Left(Helper.shared.constrain(with: .width, num: 15)),
            Width(Helper.shared.constrain(with: .width, num: 32)),
            Height(Helper.shared.constrain(with: .height, num: 32))
        ]
        
        menuButton <- [
            Bottom(Helper.shared.constrain(with: .height, num: 20)),
            Right(Helper.shared.constrain(with: .width, num: 15)),
            Width(Helper.shared.constrain(with: .width, num: 32)),
            Height(Helper.shared.constrain(with: .height, num: 32))
        ]
    }
    
    func arrowButtonPressed() {
        tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.top)
    }
    
    func menuPressed() {
  
    }

}

// MARK: UITableViewDataSource, UITableViewDelegate

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.height / 3
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objVC: DetailedNewsViewController2 = DetailedNewsViewController2()
        let aObjNavi = UINavigationController(rootViewController: objVC)
        self.present(aObjNavi, animated: true, completion: nil)
    }
    
}
