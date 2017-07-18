//
//  DetailedNewsViewController.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/17/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import Sugar
import EasyPeasy
import LMArticleViewController

class DetailedNewsViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 1000)
        return scrollView
    }()
    
    lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bg")?.original
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.text = "BLOOMBERG"
        label.font = UIFont(name: "STHeitiTC-Light", size: 11)
        label.backgroundColor = .textAqua
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Today, 12:21"
        label.font = UIFont(name: "OpenSans-Light", size: 13)
        label.textColor = .textBlack
        label.textAlignment = .left
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Semibold", size: 22)
        label.text = "Central Asia: Stans undelivered"
        label.textColor = .textBlack
        label.textAlignment = .left
        return label
    }()
    
    lazy var textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = "TAJIKISTAN has the vainest ruler in Central Asia. Emomali Rahmon flies what may be the world’s largest flag atop what used to be the world’s tallest flagpole. His capital boasts that it will soon host the region’s biggest mosque, mainly paid for by Qatar. \n \n It already has the world’s largest teahouse, mainly Chinese-financed and mostly emptyand an immense national library—sadly devoid of books, according to whispering sceptics. It already has the world’s largest teahouse.TAJIKISTAN has the vainest ruler in Central Asia. Emomali Rahmon flies what may be the world’s largest flag atop what used to be the world’s tallest flagpole. His capital boasts that it will soon host the region’s biggest mosque, mainly paid for by Qatar. \n \n It already has the world’s largest teahouse, mainly Chinese-financed and mostly emptyand an immense national library—sadly devoid of books, according to whispering sceptics. It already has the world’s largest teahouse."
        textLabel.font = UIFont(name: "OpenSans-Regular", size: 15)
        textLabel.textColor = .textBlack
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        return textLabel
    }()
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
        return view
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
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    func setupViews(){
        [newsImageView, sourceLabel, circleView, dateLabel, titleLabel, textLabel].forEach {
            scrollView.addSubview($0)
        }
        
        [scrollView, lowerBar, line].forEach {
            view.addSubview($0)
        }
        [backButton, bookmarkButton, shareButton].forEach{
            lowerBar.addSubview($0)
        }
    }
    
    func setupConstraints() {
        
        scrollView <- Edges(0)
        
        newsImageView <- [
            Width(ScreenSize.width),
            Height(Helper.shared.constrain(with: .height, num: 280)),
            Top(0)
        ]
        
        sourceLabel <- [
            Width(Helper.shared.constrain(with: .width, num: 100)),
            Height(Helper.shared.constrain(with: .height, num: 15)),
            Left(Helper.shared.constrain(with: .width, num: 10)),
            Top(Helper.shared.constrain(with: .height, num: 10)).to(newsImageView)
        ]
        
        circleView <- [
            Width(Helper.shared.constrain(with: .width, num: 3)),
            Height(Helper.shared.constrain(with: .height, num: 3)),
            Left(Helper.shared.constrain(with: .width, num: 10)).to(sourceLabel),
            Top(Helper.shared.constrain(with: .height, num: 16)).to(newsImageView)
        ]
        
        dateLabel <- [
            Width(Helper.shared.constrain(with: .width, num: 120)),
            Height(Helper.shared.constrain(with: .height, num: 15)),
            Left(Helper.shared.constrain(with: .width, num: 10)).to(circleView),
            Top(Helper.shared.constrain(with: .height, num: 10)).to(newsImageView)
        ]
        
        titleLabel <- [
            Top(Helper.shared.constrain(with: .height, num: 10)).to(sourceLabel),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Height(Helper.shared.constrain(with: .height, num: 20))
        ]
        
        textLabel <- [
            Top(Helper.shared.constrain(with: .height, num: 10)).to(titleLabel),
            Width(ScreenSize.width - Helper.shared.constrain(with: .width, num: 40)),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Bottom(0).to(lowerBar)
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
        
    }
    
    func bookmarkPressed() {
        
    }
    
    func sharePressed() {
        
    }
    
    
}
