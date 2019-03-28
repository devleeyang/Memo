//
//  CustomNavigationBar.swift
//  HRMemo
//
//  Created by 양혜리 on 26/03/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

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
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        leftButton.setImage(#imageLiteral(resourceName: "ic_arrow_back_white_22px"), for: .normal)
        
//        rightButton.snp.makeConstraints {
//            $0.centerY.equalTo(Constants.Layout.CustomNavigationBar.buttonCenterY)
//        }
//
//        leftButton.snp.makeConstraints {
//            $0.centerY.equalTo(Constants.Layout.CustomNavigationBar.buttonCenterY)
//            $0.leading.equalToSuperview().offset(Spacing.px2)
//        }
//
//        snp.makeConstraints {
//            $0.height.equalTo(Constants.Layout.CustomNavigationBar.height)
//        }
    }
}
