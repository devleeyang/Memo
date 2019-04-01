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
    let top = CustomTopView()
    let navi = CustomNavigationBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        initNaviBar()
    }
    
    func initNaviBar() {
        
        view.addSubview(top)
        view.addSubview(navi)
        
        top.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(navi.snp.top)
        }
        
        navi.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
}
