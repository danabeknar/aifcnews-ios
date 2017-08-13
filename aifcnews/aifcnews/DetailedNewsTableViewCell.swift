//
//  DetailedNewsTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/21/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

class DetailedNewsTableViewCell: UITableViewCell {

    
    var newsObject: News? {
        didSet {
            self.configureView()
        }
    }
    
    lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "STHeitiTC-Light", size: 11)
        label.backgroundColor = .textAqua
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 15)
        label.textColor = "AF3229".hexColor
        label.textAlignment = .left
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Regular", size: 23)
        label.textColor = .white
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont(name: "SFProDisplay-Regular", size: 17)
        bodyLabel.numberOfLines = 0
        bodyLabel.sizeToFit()
        bodyLabel.textColor = "989CA6".hexColor
        bodyLabel.textAlignment = .left
        return bodyLabel
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = "000B17".hexColor
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Views
    
    func setupViews() {
        [sourceLabel, dateLabel, titleLabel, bodyLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
        
//        sourceLabel <- [
//            Width(Helper.shared.constrain(with: .width, num: 100)),
//            Height(Helper.shared.constrain(with: .height, num: 15)),
//            Left(Helper.shared.constrain(with: .width, num: 10)),
//            Top(Helper.shared.constrain(with: .height, num: 10))
//        ]
        
        dateLabel <- [
            Width(Helper.shared.constrain(with: .width, num: 120)),
            Height(Helper.shared.constrain(with: .height, num: 15)),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Top(Helper.shared.constrain(with: .height, num: 13)).to(titleLabel)
        ]

        titleLabel <- [
            Top(Helper.shared.constrain(with: .height, num: 15)),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Height(heightForView(text: titleLabel.text!, font: UIFont(name: "SFProDisplay-Regular", size: 23)!, width: ScreenSize.width - 40))
        ]
        
        bodyLabel <- [
            Top(Helper.shared.constrain(with: .height, num: 11)).to(dateLabel),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Bottom(10)
        ]
    }
    
    func configureView() {
        if let newsObject = newsObject{
            titleLabel.text = newsObject.title
            dateLabel.text = String(describing: newsObject.date)
            setupConstraints()
        }
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}
