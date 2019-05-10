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
    lazy var leftButton: UIButton = UIButton()
    lazy var rightButton: UIButton = UIButton()
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var topBackView: UIView = UIView()
    lazy var bottomBackView: UIView = UIView()
    
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
        
   
        addSubview(scrollView)
        scrollView.addSubview(topBackView)
        scrollView.addSubview(bottomBackView)
        
        topBackView.addSubview(leftButton)
        topBackView.addSubview(rightButton)
        
        initViews()
        initButtons()
    }
    
    func initViews() {
        scrollView.backgroundColor = .blue
        topBackView.backgroundColor = .brown
        bottomBackView.backgroundColor = .yellow
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    
        topBackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
//            $0.bottom.equalTo(bottomBackView.snp.top)
            $0.height.equalTo(50)
        }
    
        bottomBackView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
//            $0.top.equalTo(topBackView.snp.bottom)
            $0.height.equalTo(50)
        }
    }
    
    func initButtons(){
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        leftButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        
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
