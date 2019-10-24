//
//  HRRightArrowCell.swift
//  HRMemo
//
//  Created by 양혜리 on 28/03/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

class HRRightArrowCell: UITableViewCell {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .contentTextColor
        label.font = .boldSystemFont(ofSize: 16.0)
        label.textAlignment = .left
        contentView.addSubview(label)
        return label
    }()
    
    lazy private var arrowImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "blackArrow")
        let templateImage = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.image = templateImage
        imageView.tintColor = .contentTextColor
        imageView.clipsToBounds = false
        contentView.addSubview(imageView)
        return imageView
    }()
    
    lazy private var bottomLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .grayColor
        contentView.addSubview(view)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .settingContentColor
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(arrowImg.snp.leading).offset(10)
        }
        
        arrowImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(-10)
        }
        
        bottomLine.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(0.3)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
