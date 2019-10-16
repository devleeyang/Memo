//
//  UIViewController+Extension.swift
//  HRMemo
//
//  Created by 양혜리 on 17/10/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

extension UIViewController
{
    func hideKeyboard()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
