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
    lazy var scrollContentView: UIView = UIView()
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
        scrollContentView.backgroundColor = .gray
        addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(topBackView)
        scrollContentView.addSubview(bottomBackView)
        
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
            $0.height.equalTo(scrollContentView.snp.height).priority(.low)
        }

        scrollContentView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.centerX.equalToSuperview()
            $0.height.equalTo(100.0)
        }

        topBackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(50.0)
        }
        
        bottomBackView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(50.0)
            $0.top.equalTo(topBackView.snp.bottom)
        }
        
        scrollView.contentSize = CGSize(width: self.frame.width, height: 100)
        scrollView.setNeedsLayout()
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
