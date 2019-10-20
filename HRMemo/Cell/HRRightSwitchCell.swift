//
//  HRRightSwitchCell.swift
//  HRMemo
//
//  Created by 양혜리 on 20/10/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

class HRRightSwitchCell: UITableViewCell {

    private lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.alignment = .fill
        stackView.spacing = 1.0
        stackView.axis = .vertical
        contentView.addSubview(stackView)
        return stackView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .contentTextColor
        label.font = .boldSystemFont(ofSize: 16.0)
        label.textAlignment = .left
        stackView.addArrangedSubview(label)
        return label
    }()
   
    lazy var contentLable: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .boldSystemFont(ofSize: 14.0)
        label.textAlignment = .left
        stackView.addArrangedSubview(label)
        return label
    }()
    lazy var switchView: UISwitch = {
        let swith = UISwitch()
        swith.onTintColor = .switchColor
        contentView.addSubview(swith)
        return swith
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
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.equalToSuperview().offset(10)
            $0.bottom.equalToSuperview().offset(-10.0)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalTo(switchView.snp.leading).offset(10)
        }
       
        switchView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-10)
            $0.leading.equalTo(stackView.snp.trailing).offset(-10)
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
