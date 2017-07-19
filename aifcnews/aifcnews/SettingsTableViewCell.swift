//
//  SettingsTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/19/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import Sugar

class SettingsTableViewCell: UITableViewCell {

    // MARK: Properties
    
    var cellObject: SettingsItem? {
        didSet {
            configureView()
        }
    }
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "OpenSans-Regular", size: 17)
        titleLabel.textColor = "030303".hexColor
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    lazy var cellSwitch: UISwitch = {
        let cellSwtich = UISwitch()
        return cellSwtich
    }()
    
    lazy var cellIcon: UIImageView = {
        let cellIcon = UIImageView()
        return cellIcon
    }()
    
    lazy var cellImageView: UIImageView = {
        let cellImageView = UIImageView()
        return cellImageView
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "Cell")
        separatorInset = UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)
        self.addSubviews(titleLabel, cellIcon)
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Consraints
    
    func setupConstraints() {
        cellIcon <- [
            Left(Helper.shared.constrain(with: .width, num: 10)),
            Width(Helper.shared.constrain(with: .width, num: 20)),
            Height(Helper.shared.constrain(with: .height, num: 20)),
            CenterY()
        ]
        
        titleLabel <- [
            Left(Helper.shared.constrain(with: .width, num: 15)).to(cellIcon),
            CenterY()
        ]
        
    }
    
    func addSwitch() {
        self.addSubview(cellSwitch)
        
        cellSwitch <- [
            Right(Helper.shared.constrain(with: .width, num: 10)),
            Width(Helper.shared.constrain(with: .width, num: 51)),
            Height(Helper.shared.constrain(with: .height, num: 31)),
            CenterY()
        ]
    }
    
    func configureView() {
        if let object = cellObject {
            titleLabel.text = object.title
            cellIcon.image = object.image
        }
    }
}
