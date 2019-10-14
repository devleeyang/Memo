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
    var writeView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        navigationBar.changeLeftButtonImage(imageName: "back")
        navigationBar.changeRightButtonImage(imageName: "checkmark")
        navigationBar.scrollView.isScrollEnabled = false
        
        view.backgroundColor = .white

        writeView = UITextView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        writeView.textAlignment = NSTextAlignment.justified
        writeView.textColor = .black
        writeView.font = UIFont.systemFont(ofSize: 21)
        writeView.backgroundColor = .white

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
        writeView.becomeFirstResponder()
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
        if memo.open(){
            let insertSQL = "INSERT INTO MEMO (CONTENT, DATE, TEMPT) values ('\(writeView.text! as String)', DATETIME('now'), FALSE)"
            print(insertSQL)
            let result = memo.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result{
                print("Error : memoDB add Fail, \(memo.lastError())")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
            memo.close()
        } else {
            print("Error : memoDB open Fail, \(memo.lastError())")
        }
    }
    
    func dateUpdateFromText(memo:FMDatabase) {
        if memo.open(){
            if let number = memoData["ID"] as? NSNumber {
                let updateSQL = "UPDATE MEMO SET CONTENT = '\(writeView.text! as String)', DATE = DATETIME('now'), TEMPT = FALSE WHERE ID = \(number)"
//                let updateSQL = "DELETE FROM MEMO WHERE ID = \(number)"
                print(updateSQL)
                let result = memo.executeUpdate(updateSQL, withArgumentsIn: [])
                if !result{
                    print("Error : memoDB add Fail, \(memo.lastError())")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            print("Error : memoDB open Fail, \(memo.lastError())")
        }
    }
    
    @objc func didShow()
    {
        
    }

    @objc func didHide()
    {
        
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
