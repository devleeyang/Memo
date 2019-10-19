//
//  CustomTopView.swift
//  HRMemo
//
//  Created by 양혜리 on 02/04/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit
import SnapKit

class CustomTopView: UIView {
    
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
    }
}
