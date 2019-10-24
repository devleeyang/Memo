//
//  HRIntroViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 14/10/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit
import SnapKit

class HRIntroViewController: UIViewController {
    
    lazy var leftLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 45.0)
        label.textAlignment = .center
        label.text = "EAZY"
        view.addSubview(label)
        return label
    }()
    
    lazy var rightLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 45.0)
        label.textAlignment = .center
        label.text = "MEMO"
        label.alpha = 0.0
        view.addSubview(label)
        return label
    }()
    
    lazy var centerView: UIView = {
        let centerView: UIView = UIView()
        centerView.backgroundColor = .clear
        view.addSubview(centerView)
        return centerView
    }()

    lazy var stackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 33.0/255.0, green: 144.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        centerView.snp.makeConstraints {
            $0.width.height.equalTo(1.0)
            $0.centerY.centerX.equalToSuperview()
        }
        
        leftLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        rightLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(leftLabel.snp.trailing).offset(6.0)
        }
        perform(#selector(startAnimationFromLabel), with: nil, afterDelay: 1.0)
    }
    
    @objc private func startAnimationFromLabel() {
        let x = (UIScreen.main.bounds.width - (leftLabel.frame.width + rightLabel.frame.width + 6.0)) / 2.0
        let offset = leftLabel.frame.origin.x - x
        self.rightLabel.layer.position.x -= offset
        
        UIView.animate(withDuration: 0.5, animations: {
            self.leftLabel.layer.position.x -= offset
            self.rightLabel.alpha = 1.0
        }) { _ in
            self.presentMainViewController()
        }
    }
    
    private func presentMainViewController() {
        let listViewController = HRListViewController()
        let navigationController = UINavigationController(rootViewController: listViewController)
        UIApplication.shared.keyWindow?.rootViewController = navigationController
    }
}
