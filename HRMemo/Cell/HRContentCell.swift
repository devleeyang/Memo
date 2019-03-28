//
//  HRContentCell.swift
//  HRMemo
//
//  Created by 양혜리 on 28/03/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

class HRContentCell: UITableViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        
        return label
    }()
    
    var arrowImg: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "next")
        imageView.clipsToBounds = false
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImg)
        contentView.backgroundColor = UIColor(red:224.0/255.0, green:218.0/255.0, blue:245.0/255.0, alpha:1.0)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalTo(arrowImg.snp.leading).offset(10)
        }
        
        arrowImg.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
