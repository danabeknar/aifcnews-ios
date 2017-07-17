//
//  FeedTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/14/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import Sugar

class FeedTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    lazy var backgroundImageView: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "bg")!.original
        }
    }()
    
    lazy var grView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var timeImageView: UIImageView = {
        return UIImageView().then {
            $0.image = UIImage(named: "Time")?.original
        }
    }()
    
    lazy var titleLabel: UILabel = {
        return UILabel().then {
            $0.textColor = .white
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.text = "EU Report Implies Criminals are Too Stupid to Use Bitcoin"
            $0.font = UIFont(name: "OpenSans-Regular", size: Helper.shared.constrain(with: .height, num: 18))
        }
    }()
    
    lazy var infoLabel: UILabel = {
        return UILabel().then {
            $0.textColor = .textGrey
            $0.textAlignment = .left
            $0.text = "10 minutes ago | Reuters.com"
            $0.font = UIFont(name: "OpenSans-Light", size: Helper.shared.constrain(with: .height, num: 14))
            $0.numberOfLines = 0
        }
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1, execute: {
            self.grView.setBlackGradientView()
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Views
    
    func setupViews() {
        [backgroundImageView, grView, titleLabel, timeImageView , infoLabel].forEach{
            contentView.addSubview($0)
        }
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
        backgroundImageView <- Edges(0)
        
        grView <- Edges(0)

        timeImageView <- [
            Left(Helper.shared.constrain(with: .width, num: 10)),
            Bottom(Helper.shared.constrain(with: .height, num: 13)),
            Width(Helper.shared.constrain(with: .width, num: 10)),
            Height(Helper.shared.constrain(with: .height, num: 10))
        ]
        
        infoLabel <- [
            Left(Helper.shared.constrain(with: .width, num: 5)).to(timeImageView),
            Bottom(Helper.shared.constrain(with: .height, num: 8)),
            Width(Helper.shared.constrain(with: .width, num: 200))
        ]
        
        titleLabel <- [
            Left(Helper.shared.constrain(with: .width, num: 10)),
            Right(Helper.shared.constrain(with: .width, num: 10)),
            Height(Helper.shared.constrain(with: .height, num: 50)),
            Bottom(Helper.shared.constrain(with: .height, num: 10)).to(infoLabel)
        ]
    }
}
