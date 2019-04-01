//
//  CustomNavigationBar.swift
//  HRMemo
//
//  Created by 양혜리 on 26/03/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit
import SnapKit

class CustomNavigationBar: UIView {
    let leftButton: UIButton = UIButton()
    let rightButton: UIButton = UIButton()
    
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
        self.backgroundColor = .green
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        leftButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        initButtons()
    }
    func initButtons(){
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
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
