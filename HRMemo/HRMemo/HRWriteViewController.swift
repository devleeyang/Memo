//
//  HRWriteViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 20/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit

class HRWriteViewController: UIViewController {
    
    var memoData = Dictionary<String,Any>()
    @IBOutlet weak var writeView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: self, action: #selector(self.pressedSaveMemo))
        if (!memoData.isEmpty) {
            self.writeView.text = memoData["CONTENT"] as? String
        }
//        btn
//        self.navigationItem.rightBarButtonItem
    }

    @objc func pressedSaveMemo() {
        
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

}
