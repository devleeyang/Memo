//
//  HRListCell.swift
//  HRMemo
//
//  Created by 양혜리 on 20/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit

class HRListCell: UITableViewCell {
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textAlignment = .left
        contentView.addSubview(label)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .contentTextColor
        label.font = UIFont.systemFont(ofSize: 21)
        label.textAlignment = .left
        label.numberOfLines = 1
        contentView.addSubview(label)
        return label
    }()
    
    lazy private var bottomLine: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor(red: 200.0/255.0, green: 200.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        view.backgroundColor = .grayColor
        contentView.addSubview(view)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        contentView.backgroundColor = .contentColor
        dateLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.bottom.equalTo(contentLabel.snp.top).offset(-10)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
        }
        
        bottomLine.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.height.equalTo(0.3)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
