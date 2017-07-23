//
//  BookmarkViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/23/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

class BookmarkViewController: UIViewController {

    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.layer.borderWidth = 0
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()

    lazy var lowerBar: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = .barGrey
        return view
    }()
    
    lazy var line: UIView = {
        let view = UIView()
        view.alpha = 0
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
        view.backgroundColor = .backgroundGrey
        setupViews()
        setupConstraints()
    }
    
    
    func setupViews(){
        view.addSubviews(tableView, line, lowerBar)
        lowerBar.addSubview(dismissButton)
    }
    
    func setupConstraints() {
        tableView <- [
            Top(0),
            Width(ScreenSize.width),
            Bottom(0)
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

// MARK: UITableViewDataSource, UITableViewDelegate

extension BookmarkViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 209
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.present(DetailedNewsViewController(), animated: true, completion: nil)
    }
    
}
