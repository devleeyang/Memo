//
//  HREmptyCell.swift
//  HRMemo
//
//  Created by 양혜리 on 11/10/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

class HREmptyCell: UITableViewCell {
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 21)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "기록이 아직 없네요\n잊지 않게 메모를 시작해보아요:)"
        contentView.addSubview(label)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
    
           contentLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10)
           }
       }
       
       required init?(coder aDecoder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
}
