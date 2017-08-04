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
        label.font = UIFont(name: "OpenSans-Light", size: 13)
        label.textColor = .textBlack
        label.textAlignment = .left
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "OpenSans-Semibold", size: 20)
        label.textColor = .textBlack
        label.sizeToFit()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var bodyLabel: UILabel = {
        let bodyLabel = UILabel()
        bodyLabel.font = UIFont(name: "OpenSans-Regular", size: 16)
        bodyLabel.numberOfLines = 0
        bodyLabel.sizeToFit()
        bodyLabel.textColor = .textBlack
        bodyLabel.textAlignment = .left
        return bodyLabel
    }()
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 2
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
    
    // MARK: Configure Views
    
    func setupViews() {
        contentView.addSubviews(sourceLabel, dateLabel, titleLabel, circleView, bodyLabel, circleView)
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
        
        sourceLabel <- [
            Width(Helper.shared.constrain(with: .width, num: 100)),
            Height(Helper.shared.constrain(with: .height, num: 15)),
            Left(Helper.shared.constrain(with: .width, num: 10)),
            Top(Helper.shared.constrain(with: .height, num: 10))
        ]
        
        circleView <- [
            Width(Helper.shared.constrain(with: .width, num: 3)),
            Height(Helper.shared.constrain(with: .height, num: 3)),
            Left(Helper.shared.constrain(with: .width, num: 10)).to(sourceLabel),
            Top(Helper.shared.constrain(with: .height, num: 16))
        ]
        
        dateLabel <- [
            Width(Helper.shared.constrain(with: .width, num: 120)),
            Height(Helper.shared.constrain(with: .height, num: 15)),
            Left(Helper.shared.constrain(with: .width, num: 10)).to(circleView),
            Top(Helper.shared.constrain(with: .height, num: 10))
        ]
        


    }
    
    func configureView() {
        if let newsObject = newsObject{
            sourceLabel.text = newsObject.source?.uppercased()
            titleLabel.text = newsObject.title
            bodyLabel.text = newsObject.body
            if let date = newsObject.date{
                let index = date.index((date.startIndex), offsetBy: 10)
                let clearDate = date.substring(to: index)
                dateLabel.text = clearDate
            }
    
            titleLabel <- [
                Top(Helper.shared.constrain(with: .height, num: 10)).to(sourceLabel),
                Left(Helper.shared.constrain(with: .width, num: 20)),
                Right(Helper.shared.constrain(with: .width, num: 20)),
                Height(heightForView(text: titleLabel.text!, font: UIFont(name: "OpenSans-Semibold", size: 20)!, width: ScreenSize.width - 40))
            ]
            
            bodyLabel <- [
                Top(Helper.shared.constrain(with: .height, num: 5)).to(titleLabel),
                Width(ScreenSize.width - Helper.shared.constrain(with: .width, num: 40)),
                Left(Helper.shared.constrain(with: .width, num: 20)),
                Right(Helper.shared.constrain(with: .width, num: 20)),
                Bottom(10)
            ]
            
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
