//
//  CollapsibleTableViewHeader.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/19/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

protocol CollapsibleTableViewHeaderDelegate {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {
    
    var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    var tagObject: Tag? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
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
    
    let arrowLabel = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
        setupViews()
        setupConstraints()
    }
    
    func setupViews() {
        [tagLabel, arrowLabel, circleView].forEach{
            contentView.addSubview($0)
        }
        
    }
    
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
            Width(Helper.shared.constrain(with: .width, num: 200)),
            CenterY()
        ]
        
        arrowLabel <- [
            Height(Helper.shared.constrain(with: .height, num: 27)),
            Right(Helper.shared.constrain(with: .width, num: 30)),
            CenterY()
        ]
        
    }
    
    func configureView(){
        if let tag = tagObject {
            circleView.backgroundColor = tag.color
            tagLabel.text = tag.tag
            arrowLabel.text = ">"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        // Animate the arrow rotation (see Extensions.swf)
        arrowLabel.rotate(collapsed ? 0.0 : .pi / 2)
    }
    
}
