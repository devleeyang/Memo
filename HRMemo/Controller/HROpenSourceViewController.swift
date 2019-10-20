//
//  HROpenSourceViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 20/10/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit

class HROpenSourceViewController: BaseViewController {
    private lazy var textView: UITextView = {
        let textView: UITextView = UITextView()
        textView.isEditable = false
        textView.textColor = .contentTextColor
        textView.showsVerticalScrollIndicator = false
        view.addSubview(textView)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .contentColor
        textView.backgroundColor = .contentColor
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationBar.changeLeftButtonImage(imageName: "back")
        navigationBar.scrollView.isScrollEnabled = false
        
        textView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
        }
        loadLicense()
    }
    
    private func loadLicense() {
        if let path = Bundle.main.path(forResource: "ACKNOWLEDGEMENT", ofType: "md") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let str = String(data: data, encoding: String.Encoding.utf8)
                textView.text = str
            } catch {
                   // handle error
            }
        }
    }
}

extension HROpenSourceViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
