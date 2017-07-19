//
//  TagsTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/18/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import  Sugar

class TagsTableViewCell: UITableViewCell {

    
    // MARK: Properties
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8.5
        view.backgroundColor = .mainBlue
        return view
    }()
    
    lazy var tagLabel: UILabel = {
        return UILabel().then {
            $0.textColor = .textCellBlack
            $0.textAlignment = .left
            $0.font = UIFont(name: "OpenSans-Regular", size: Helper.shared.constrain(with: .height, num: 20))
        }
    }()
    
    lazy var checkmarkView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Tick")?.original
        view.alpha = 0
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        [circleView, tagLabel, checkmarkView].forEach{
            contentView.addSubview($0)
        }
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
  
        circleView <- [
            Left(Helper.shared.constrain(with: .width, num: 30)),
            Height(Helper.shared.constrain(with: .height, num: 17)),
            Width(Helper.shared.constrain(with: .width, num: 17)),
            CenterY()
        ]
        
        tagLabel <- [
            Left(Helper.shared.constrain(with: .width, num: 35)).to(circleView),
            Height(Helper.shared.constrain(with: .height, num: 27)),
            Width(Helper.shared.constrain(with: .width, num: 150)),
            CenterY()
        ]
        
        checkmarkView <- [
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Height(Helper.shared.constrain(with: .height, num: 20)),
            Width(Helper.shared.constrain(with: .width, num: 20)),
            CenterY()
        ]
    }
    
    func isSelected(_ bool: Bool) { 
        checkmarkView.alpha = bool ? 1 : 0
    }
}
