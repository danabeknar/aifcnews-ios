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
    
    var subtag: Subtag? {
        didSet {
            self.configureView()
        }
    }
    
    var cellTag: String?

    
    lazy var circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.backgroundColor = .mainBlue
        return view
    }()
    
    lazy var subtagLabel: UILabel = {
        return UILabel().then {
            $0.textColor = .textCellBlack
            $0.textAlignment = .left
            $0.font = UIFont(name: "OpenSans-Light", size: Helper.shared.constrain(with: .height, num: 15))
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
        [circleView, subtagLabel, checkmarkView].forEach{
            contentView.addSubview($0)
        }
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
  
        circleView <- [
            Left(Helper.shared.constrain(with: .width, num: 60)),
            Height(Helper.shared.constrain(with: .height, num: 12)),
            Width(Helper.shared.constrain(with: .width, num: 12)),
            CenterY()
        ]
        
        subtagLabel <- [
            Left(Helper.shared.constrain(with: .width, num: 15)).to(circleView),
            Height(Helper.shared.constrain(with: .height, num: 27)),
            Right(Helper.shared.constrain(with: .width, num: 40)),
            CenterY()
        ]
        
        checkmarkView <- [
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Height(Helper.shared.constrain(with: .height, num: 15)),
            Width(Helper.shared.constrain(with: .width, num: 15)),
            CenterY()
        ]
    }
    
    override func prepareForReuse() {
        checkmarkView.alpha = 1
    }
    
    func configureView() {
        if let subtag = subtag?.subtag {
            subtagLabel.text = subtag
        }
    }

    
    func isSelected(_ bool: Bool) { 
        checkmarkView.alpha = bool ? 1 : 0
    }
}
