//
//  FeedTableViewCell.swift
//  aifcnews
//
//  Created by Beknar Danabek on 7/14/17.
//  Copyright © 2017 nFactorial Incubator. All rights reserved.
//

import UIKit
import EasyPeasy
import SwiftDate
import Kingfisher

class FeedTableViewCell: UITableViewCell {

    // MARK: Properties

    var newsObject: News? {
        didSet {
            self.configureView()
        }
    }

    lazy var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.kf.indicatorType = .activity
        imageView.layer.cornerRadius = 3
        return imageView
    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont(name: "SFProDisplay-Light", size: Helper.shared.constrain(with: .height, num: 17))
        return label
    }()

    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = "989CA6".hexColor
        label.textAlignment = .left
        label.sizeToFit()
        label.font = UIFont(name: "SFProDisplay-Light", size: 12)
        label.numberOfLines = 0
        return label
    }()

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.1)
        return view
    }()

    lazy var bookmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "FilledBookmark")?.withRenderingMode(.alwaysOriginal)
        imageView.isHidden = true
        return imageView
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
        [titleLabel, dateLabel, lineView, bookmarkImageView, newsImageView].forEach {
            contentView.addSubview($0)
        }

    }

    // MARK: Configure Constraints

    func setupConstraints() {
        dateLabel.easy.layout(
            Left(Helper.shared.constrain(with: .width, num: 20)),
            Bottom(Helper.shared.constrain(with: .height, num: 20)),
            Width(Helper.shared.constrain(with: .width, num: 70)),
            Height(Helper.shared.constrain(with: .height, num: 16))
        )

        newsImageView.easy.layout(
            Right(Helper.shared.constrain(with: .width, num: 20)),
            Width(Helper.shared.constrain(with: .width, num: 70)),
            Height(Helper.shared.constrain(with: .height, num: 80)),
            Bottom(Helper.shared.constrain(with: .height, num: 20))
        )

        titleLabel.easy.layout(
            Top(Helper.shared.constrain(with: .height, num: 20)),
            Left(Helper.shared.constrain(with: .width, num: 17)),
            Right(Helper.shared.constrain(with: .width, num: 10)).to(newsImageView),
            Bottom(Helper.shared.constrain(with: .height, num: 10)).to(dateLabel)
        )

        bookmarkImageView.easy.layout(
            Bottom(Helper.shared.constrain(with: .height, num: 22)),
            Left(Helper.shared.constrain(with: .width, num: 5)).to(dateLabel),
            Height(9),
            Width(6)
        )

        lineView.easy.layout(
            Width(ScreenSize.width),
            Height(1),
            Bottom(0)
        )
    }

    func showBookmark() {
        bookmarkImageView.isHidden = false
    }

    func configureView() {
        setupImage()
        if let newsObject = newsObject {
            if let title = newsObject.title, let date = newsObject.date {
                let (colloquial, _) = try! date.colloquialSinceNow()
                titleLabel.text = title
                dateLabel.text = colloquial
            } else {
                return
            }

        }
    }

    func setupImage() {
        if let news = newsObject {
            if let imageLink = news.imageLink {
                if let modifiedURL = URL(string: "http:\(imageLink)") {
                newsImageView.kf.setImage(with: modifiedURL)
                }
            } else {
                newsImageView.image = UIImage(named: "notFound")
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bookmarkImageView.isHidden = true
    }
}
