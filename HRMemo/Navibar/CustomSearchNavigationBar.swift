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
    lazy var leftButton: UIButton = UIButton()
    lazy var rightButton: UIButton = UIButton()
    lazy var textField: UITextField = UITextField()
    
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
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        leftButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        rightButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        
        initButtons()
    }
    
    func initButtons(){
        leftButton.snp.makeConstraints {
            $0.top.bottom.leading.equalToSuperview()
            $0.width.equalTo(50)
        }
        
        rightButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.width.equalTo(50)
        }
    }
}
