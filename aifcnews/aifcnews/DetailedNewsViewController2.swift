//
//  DetailedNewsViewController2.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/18/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import LMArticleViewController

class DetailedNewsViewController2: LMArticleViewController {

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
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "LeftArrow")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bookmark")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(bookmarkPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Upload")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(sharePressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupViews()
        setupConstraints()
    }

    func configureView() {
        self.headlineFont = UIFont(name: "OpenSans-Semibold", size: 22)
        self.headlineColor = .textBlack
        self.authorFont = UIFont(name: "OpenSans-Light", size: 13)
        self.authorColor = .textGrey
        self.dateFont = UIFont(name: "OpenSans-Light", size: 13)
        self.dateColor = .textBlack
        
        
        self.headline       = "Central Asia: Stans undelivered"
        self.image          = UIImage(named: "bg")
        self.author         = "BLOOMBERG"
        self.body           = "TAJIKISTAN has the vainest ruler in Central Asia. Emomali Rahmon flies what may be the world’s largest flag atop what used to be the world’s tallest flagpole. His capital boasts that it will soon host the region’s biggest mosque, mainly paid for by Qatar. \n \n It already has the world’s largest teahouse, mainly Chinese-financed and mostly emptyand an immense national library—sadly devoid of books, according to whispering sceptics. It already has the world’s largest teahouse.TAJIKISTAN has the vainest ruler in Central Asia. Emomali Rahmon flies what may be the world’s largest flag atop what used to be the world’s tallest flagpole. His capital boasts that it will soon host the region’s biggest mosque, mainly paid for by Qatar. \n \n It already has the world’s largest teahouse, mainly Chinese-financed and mostly emptyand an immense national library—sadly devoid of books, according to whispering sceptics. It already has the world’s largest teahouse."
        
        self.bodyColor = .textBlack
        self.date           = NSDate() as Date!
        
    }

    func setupViews() {
        [lowerBar, line].forEach {
            view.addSubview($0)
        }
        [backButton, bookmarkButton, shareButton].forEach{
            lowerBar.addSubview($0)
        }
    }

    func setupConstraints() {
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
        
        backButton <- [
            Left(Helper.shared.constrain(with: .height, num: 10)),
            Top(Helper.shared.constrain(with: .height, num: 14)),
            Bottom(Helper.shared.constrain(with: .height, num: 14)),
            Width(Helper.shared.constrain(with: .width, num: 25))
        ]
        
        shareButton <- [
            Right(Helper.shared.constrain(with: .width, num: 15)),
            Top(Helper.shared.constrain(with: .height, num: 13)),
            Bottom(Helper.shared.constrain(with: .height, num: 13)),
            Width(Helper.shared.constrain(with: .width, num: 19))
        ]
        
        bookmarkButton <- [
            Right(Helper.shared.constrain(with: .width, num: 15)).to(shareButton),
            Top(Helper.shared.constrain(with: .height, num: 17)),
            Bottom(Helper.shared.constrain(with: .height, num: 13)),
            Width(Helper.shared.constrain(with: .width, num: 15))
        ]
    }
    
    func backPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    func bookmarkPressed() {
        
    }
    
    func sharePressed() {
        
    }
    
    
}
