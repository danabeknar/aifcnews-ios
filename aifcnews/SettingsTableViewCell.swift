//
//  SettingsTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/19/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy

class SettingsTableViewCell: UITableViewCell {

    // MARK: Properties

    var cellObject: SettingsItem? {
        didSet {
            configureView()
        }
    }

    lazy var titleLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.textColor = .white
        versionLabel.textAlignment = .left
        return versionLabel
    }()

    lazy var versionLabel: UILabel = {
        let versionLabel = UILabel()
        versionLabel.textColor = .white
        versionLabel.textAlignment = .left
        versionLabel.text = "1.0"
        return versionLabel
    }()

    // MARK: Initialization

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "Cell")
        separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        setupViews()
        setupConstraints()
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        versionLabel.text = "\(versionNumber).\(buildNumber)"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configure Views

    func setupViews() {
        self.addSubview(titleLabel)
    }

    // MARK: Configure Constraints

    func setupConstraints() {
        titleLabel.easy.layout(
            Left(Helper.shared.constrain(with: .width, num: 15)),
            CenterY()
        )
    }

    // MARK: Label Adding Function

    func addLabel() {
        self.addSubview(versionLabel)
        versionLabel.easy.layout(
            Right(Helper.shared.constrain(with: .width, num: 16)),
            CenterY()
        )
    }

    // MARK: Configure UI

    func configureView() {
        if let object = cellObject {
            versionLabel.text = object.title
        }
    }
}
