//
//  HRListCell.swift
//  HRMemo
//
//  Created by 양혜리 on 20/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit

class HRListCell: UITableViewCell {
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        
        return label
    }()
    
    var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 21)
        label.textAlignment = .left
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(dateLabel)
        contentView.addSubview(contentLabel)
        dateLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().offset(10)
            $0.bottom.equalTo(contentLabel.snp.top).offset(-10)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
