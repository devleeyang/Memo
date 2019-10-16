//
//  CustomTextField.swift
//  HRMemo
//
//  Created by 양혜리 on 17/10/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    // MARK: - construction
    init() {
        super.init(frame: .zero)
        self.commonConfigure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonConfigure() {
        clearButtonMode = .always
        backgroundColor = .white
        layer.cornerRadius = 17.0
        textColor = .black
        attributedPlaceholder = NSAttributedString(string: "검색어를 입력해주세요!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.grayColor])
        returnKeyType = .search
    }
    
    // MARK: - bounds
    private let offset: CGFloat = 10.0
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: offset, y: bounds.origin.y, width: bounds.width, height: bounds.height)
    }
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: offset, y: bounds.origin.y, width: bounds.width - offset, height: bounds.height)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: offset, y: bounds.origin.y, width: bounds.width - offset, height: bounds.height)
    }
}
