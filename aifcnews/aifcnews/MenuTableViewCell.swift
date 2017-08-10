//
//  FeedTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/14/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

class MenuTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont(name: "SFProDisplay-Regular", size: Helper.shared.constrain(with: .height, num: 24))
        return label
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
        contentView.addSubview(titleLabel)
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {

        titleLabel <- [
            Center(),
            Width(110),
            Height(30)
        ]

    }
}
