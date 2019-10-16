//
//  CustomSearchNavigationBar.swift
//  HRMemo
//
//  Created by huraypositive on 02/05/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit
import SnapKit

class CustomSearchNavigationBar: UIView {
 
    
    lazy var leftButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        addSubview(button)
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        addSubview(button)
        return button
    }()
    
    lazy var textField: CustomTextField = {
        let textField: CustomTextField = CustomTextField()
        addSubview(textField)
        return textField
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        clipsToBounds = true
        backgroundColor = .white

        initButtons()
        initTextField()
    }
    
    private func initButtons(){
        rightButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        leftButton.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(50)
        }
    }
    
    private func initTextField() {
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8.0)
            $0.bottom.equalToSuperview().offset(-8.0)
            $0.leading.equalTo(leftButton.snp.trailing).offset(4.0)
            $0.trailing.equalTo(rightButton.snp.leading).offset(-4.0)
        }
    }
}
