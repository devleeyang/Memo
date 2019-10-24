//
//  HRWriteViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 20/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit

class HRWriteViewController: BaseViewController {
    var memoData: [String : Any] = [String : Any]()
    lazy var writeView: UITextView = UITextView()
    
    private lazy var titleLabel: UILabel = {
       let label: UILabel = UILabel()
       label.textColor = .white
       label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
       label.textAlignment = .center
       return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        navigationBar.changeLeftButtonImage(imageName: "back")
        navigationBar.changeRightButtonImage(imageName: "checkmark")
        navigationBar.scrollView.isScrollEnabled = false
        
        view.backgroundColor = UIColor.contentColor

        writeView = UITextView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        writeView.textAlignment = .justified
        writeView.textColor = .contentTextColor
        writeView.font = UIFont.systemFont(ofSize: 21)
        writeView.backgroundColor = .contentColor

        view.addSubview(writeView)
        
        if (!memoData.isEmpty) {
            self.writeView.text = memoData["CONTENT"] as? String
        }
        
        writeView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.leading.equalToSuperview().offset(20)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if memoData.isEmpty {
            writeView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
 
    override func pressRightButton(_ sender: UIButton) {
         pressedSaveMemo()
     }
    
    private func pressedSaveMemo() {
        // 파일 찾기, 유저 홈 위치
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        // Document 경로
        let docsDir = dirPath[0]
        let databasePath = docsDir.appending("/memo.db")
        
        let memoDB = FMDatabase(path: databasePath)
        
        if (memoData.isEmpty) {
            dataInsertFromText(memo: memoDB)
        } else {
            dateUpdateFromText(memo: memoDB)
        }
    }
    
    func dataInsertFromText(memo:FMDatabase) {
        guard writeView.text.count > 0,
            let text = writeView.text
            else {
                let alertController = UIAlertController(title: "메모입력", message: "메모 내용을 채워주세요:)", preferredStyle: .alert)
                let checkButton = UIAlertAction(title: "확인", style: .default) { _ in
                alertController.dismiss(animated: true)
                }
                alertController.addAction(checkButton)
                present(alertController, animated: true)
                return
        }
        
        if memo.open(){
            let insertSQL = "INSERT INTO MEMO (CONTENT, DATE, TEMPT) values ('\(text)', DATETIME('now'), FALSE)"
            let result = memo.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result{
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            memo.close()
        } else {
        }
    }
    
    func dateUpdateFromText(memo:FMDatabase) {
        if memo.open(){
            if let number = memoData["ID"] as? NSNumber {
                let updateSQL = "UPDATE MEMO SET CONTENT = '\(writeView.text! as String)', DATE = DATETIME('now'), TEMPT = FALSE WHERE ID = \(number)"
                print(updateSQL)
                let result = memo.executeUpdate(updateSQL, withArgumentsIn: [])
                if !result{
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
        }
    }
    
    @objc func didShow()
    {
        if memoData.isEmpty {
            titleLabel.text = "새로운 메모 입력중!"
        } else {
            titleLabel.text = "메모 수정중!"
        }
        addTitleLabelFromSupverView()
    }

    @objc func didHide()
    {
        titleLabel.removeFromSuperview()
    }
    
    private func addTitleLabelFromSupverView() {
        navigationBar.topBackView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }
}

extension HRWriteViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
}
