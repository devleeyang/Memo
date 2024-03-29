//
//  ScrollView+Extension.swift
//  HRMemo
//
//  Created by 양혜리 on 10/10/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

extension UIScrollView {
    func scrollToView(view: UIView) {
        
        if let origin = view.superview {
            
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            let bottomOffset = scrollBottomOffset()
            
            if (childStartPoint.y > bottomOffset.y) {
                setContentOffset(bottomOffset, animated: true)
            } else {
                setContentOffset(CGPoint(x: 0, y: childStartPoint.y), animated: true)
            }
        }
    }
    
    func scrollToTop() {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: true)
    }

    func scrollToBottom() {
        let bottomOffset = scrollBottomOffset()
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
 
    private func scrollBottomOffset() -> CGPoint {
        return CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
    }
}
