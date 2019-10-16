//
//  BaseViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 02/04/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    let topView = CustomTopView()
    let navigationBar = CustomNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        initNaviBar()
        navigationBar.leftButton.addTarget(self, action: #selector(pressLeftButton(_:)), for: .touchUpInside)
        navigationBar.rightButton.addTarget(self, action: #selector(pressRightButton(_:)), for: .touchUpInside)
        navigationBar.bottomRightButton.addTarget(self, action: #selector(pressBottomRightButton(_:)), for: .touchUpInside)
        topView.backgroundColor = UIColor.navigationBarColor
        navigationBar.backgroundColor = UIColor.navigationBarColor
    }
    
    func initNaviBar() {
        view.addSubview(topView)
        view.addSubview(navigationBar)
        
        topView.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navigationBar.snp.top)
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    @objc func pressLeftButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pressRightButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func pressBottomRightButton(_ sender: UIButton) {
        navigationBar.scrollView.scrollToTop()
    }
}
