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
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "TAJIKISTAN has the vainest ruler in Central Asia. Emomali Rahmon flies what may be the world’s largest flag atop what used to be the world’s tallest flagpole. His capital boasts that it will soon host the region’s biggest mosque, mainly paid for by Qatar. \n \n It already has the world’s largest teahouse, mainly Chinese-financed and mostly emptyand an immense national library—sadly devoid of books, according to whispering sceptics. It already has the world’s largest teahouse.TAJIKISTAN has the vainest ruler in Central Asia. Emomali Rahmon flies what may be the world’s largest flag atop what used to be the world’s tallest flagpole. His capital boasts that it will soon host the region’s biggest mosque, mainly paid for by Qatar. \n \n It already has the world’s largest teahouse, mainly Chinese-financed and mostly emptyand an immense national library—sadly devoid of books, according to whispering sceptics. It already has the world’s largest teahouse."
        textView.font = UIFont(name: "OpenSans-Regular", size: 15)
        textView.textColor = .textBlack
        textView.textAlignment = .left
        textView.isEditable = false
        return textView
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
        contentView.addSubviews(sourceLabel, dateLabel, titleLabel, circleView, textView, circleView)
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
        
        titleLabel <- [
            Top(Helper.shared.constrain(with: .height, num: 10)).to(sourceLabel),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Height(Helper.shared.constrain(with: .height, num: 20))
        ]
        
        textView <- [
            Top(Helper.shared.constrain(with: .height, num: 10)).to(titleLabel),
            Width(ScreenSize.width - Helper.shared.constrain(with: .width, num: 40)),
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Bottom(0)
        ]

    }


}
