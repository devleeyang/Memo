//
//  UIColor+Extension.swift
//  HRMemo
//
//  Created by 양혜리 on 15/10/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

extension UIColor {
    static var navigationBarColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 18.0/255.0, green: 18.0/255.0, blue: 18.0/255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 33.0/255.0, green: 144.0/255.0, blue: 173.0/255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 33.0/255.0, green: 144.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        }
    }
    
    static var settingContentColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 28.0/255.0, green: 28.0/255.0, blue: 28.0/255.0, alpha: 1.0)
                } else {
                    return white
                }
            }
        } else {
            return white
        }
    }
    
    static var contentColor: UIColor {
        if #available(iOS 13, *) {
           return UIColor { (traitCollection: UITraitCollection) -> UIColor in
               if traitCollection.userInterfaceStyle == .dark {
                    return .black
               } else {
                return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
               }
           }
        } else {
            return UIColor(red: 250.0/255.0, green: 250.0/255.0, blue: 250.0/255.0, alpha: 1.0)
        }
    }
    
    static var contentTextColor: UIColor {
        if #available(iOS 13, *) {
           return UIColor { (traitCollection: UITraitCollection) -> UIColor in
               if traitCollection.userInterfaceStyle == .dark {
                    return .white
               } else {
                    return .black
               }
           }
        } else {
           return .black
        }
    }
    
    static var addButtonColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 55.0/255.0, green: 185.0/255.0, blue: 255.0/255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 55.0/255.0, green: 185.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        }
    }
    
    static var grayColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 99.0/255.0, green: 99.0/255.0, blue: 102.0/255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        }
    }
    
    static var settingBottomLineColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return clear
                } else {
                    return UIColor(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 174.0/255.0, green: 174.0/255.0, blue: 174.0/255.0, alpha: 1.0)
        }
    }
    
    static var switchColor: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection: UITraitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return UIColor(red: 50.0/255.0, green: 201.0/255.0, blue: 88.0/255.0, alpha: 1.0)
                } else {
                    return UIColor(red: 33.0/255.0, green: 144.0/255.0, blue: 173.0/255.0, alpha: 1.0)
                }
            }
        } else {
            return UIColor(red: 33.0/255.0, green: 144.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        }
    }
}
