//
//  FeedTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/14/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

class FeedTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    var newsObject: News? {
        didSet {
            self.configureView()
        }
    }
    
//    lazy var newsImageView: UIImageView = {
//        let newsImageView = UIImageView()
//        newsImageView.contentMode = .scaleAspectFill
//        newsImageView.clipsToBounds = true
//        newsImageView.layer.cornerRadius = 5
//        newsImageView.kf.indicatorType = .activity
//        return newsImageView
//    }()

    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
            label.textColor = .white
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = UIFont(name: "SFProDisplay-Light", size: Helper.shared.constrain(with: .height, num: 18))
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
            label.textColor = "989CA6".hexColor
            label.textAlignment = .left
            label.font = UIFont(name: "SFProDisplay-Light", size: Helper.shared.constrain(with: .height, num: 12))
            label.numberOfLines = 0
        return label
    }()
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        return view
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        contentView.backgroundColor = "000B17".hexColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Views
    
    func setupViews() {
        [titleLabel, infoLabel, lineView].forEach{
            contentView.addSubview($0)
        }
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
//        newsImageView <- [
//            Top(Helper.shared.constrain(with: .height, num: 20)),
//            Bottom(Helper.shared.constrain(with: .height, num: 20)),
//            Right(Helper.shared.constrain(with: .width, num: 14)),
//            Width(Helper.shared.constrain(with: .width, num: 118))
//        ]

        infoLabel <- [
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Bottom(Helper.shared.constrain(with: .height, num: 20)),
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Height(Helper.shared.constrain(with: .height, num: 16))
        ]
        
        titleLabel <- [
            Top(Helper.shared.constrain(with: .height, num: 20)),
            Left(Helper.shared.constrain(with: .width, num: 17)),
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Bottom(Helper.shared.constrain(with: .height, num: 10)).to(infoLabel)
        ]
        
        lineView <- [
            Width(ScreenSize.width),
            Height(1),
            Bottom(0)
        ]
    }
    
    func configureView() {
        if let newsObject = newsObject{
            guard let title = newsObject.title,
                  let date = newsObject.date
                else {
                    return
                }
            titleLabel.text = title
            infoLabel.text = date
        }
    }
    
}
