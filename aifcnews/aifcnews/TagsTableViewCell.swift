//
//  TagsTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/18/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

class TagsTableViewCell: UITableViewCell {

    
    // MARK: Properties
    
    var isChosen = false {
        didSet {
//            choose(isChosen)
        }
    }
    
    var tagObject: Tag? {
        didSet {
            self.configureView()
        }
    }
    
    var tagAction: (TagsTableViewCell) -> Void = { cell in }
    
    lazy var tagLabel: UILabel = {
        let label = UILabel()
            label.textColor = .white
            label.textAlignment = .left
            label.font = UIFont(name: "SFProDisplay-Light", size: Helper.shared.constrain(with: .height, num: 18))
        return label
    }()
    
    lazy var signButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(signDidPress), for: .touchUpInside)
        return button
    }()
    
    // MARK: Initialization
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        self.textLabel?.textColor = .white
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configure Views
    
    func setupViews() {
        [tagLabel, signButton].forEach{
            contentView.addSubview($0)
        }
    }
    
    // MARK: Configure Constraints
    
    func setupConstraints() {
  
        tagLabel <- [
            Left(Helper.shared.constrain(with: .width, num: 15)),
            Height(Helper.shared.constrain(with: .height, num: 27)),
            Right(Helper.shared.constrain(with: .width, num: 40)),
            CenterY()
        ]
        
        signButton <- [
            Right(Helper.shared.constrain(with: .width, num: 24)),
            CenterY()
        ]
    }
    
    // MARK: Configure UI
    
    func configureView() {
        if let tag = tagObject?.tag {
            tagLabel.text = tag
        }
    }
    
    // MARK: Sign DidPress Function

    func signDidPress(sender: UIButton) {
        tagAction(self)
    }

    
}
