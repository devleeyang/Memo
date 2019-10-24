//
//  ViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 19/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    var databasePath = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib. // DB Check
        let fileMgr = FileManager.default
        
        // 파일 찾기, 유저 홈 위치
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        // Document 경로
        let docsDir = dirPath[0]
        print(docsDir)
        
        // Document/contacts.db라는 경로(커스터마이징 db임)
        databasePath = docsDir.appending("/memo.db")
        print(databasePath)
        
        if !fileMgr.fileExists(atPath: databasePath) {
            // DB 접속
            let memoDB = FMDatabase(path: databasePath)
            
            if memoDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS CONTACTS ( ID INTEGER PRIMARY KEY AUTOINCREMENT, CONTENT TEXT, DATE DATE('now'), TEMPT BOOL )"
                if !memoDB.executeStatements(sql_stmt){
                    print("Error : memoDB execute Fail, \(memoDB.lastError())")
                }
                memoDB.close()
                
            } else {
                print("Error : memoDB open Fail, \(memoDB.lastError())")
            }
        } else {
            print("memoDB is exist")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        // DB접속
        let memoDB = FMDatabase(path: databasePath)
        if memoDB.open(){
            print("[Save to DB Name : \(nameTextField.text!) Age : \(ageTextField.text!)")
            let insertSQL = "INSERT INTO CONTACTS (NAME, AGE) values ('\(nameTextField.text!)', '\(ageTextField.text!)')"
            print(insertSQL)
            let result = memoDB.executeUpdate(insertSQL, withArgumentsIn: [])
            if !result{
                resultLabel.text = "Fail to add contact"
                print("Error : memoDB add Fail, \(memoDB.lastError())")
            } else {
                resultLabel.text = "Success to add contact"
                nameTextField.text = ""
                ageTextField.text = ""
            }
        } else {
            print("Error : memoDB open Fail, \(memoDB.lastError())")
        }
    }
    
    @IBAction func findBtnClicked(_ sender: UIButton) {
        // DB접속
        let memoDB = FMDatabase(path: databasePath)
        if memoDB.open(){
            print("[Find to DB Name : \(nameTextField.text!) Age : \(ageTextField.text!)")
            let selectSQL = "SELECT NAME, AGE FROM CONTACTS WHERE NAME = '\(nameTextField.text!)'"
            print(selectSQL)
            do {
                let result = try memoDB.executeQuery(selectSQL, values: [])
                if result.next(){
                    ageTextField.text = result.string(forColumn: "AGE")
                    resultLabel.text = "\(result.string(forColumn: "NAME")!) find!"
                } else {
                    nameTextField.text = ""
                    ageTextField.text = ""
                    resultLabel.text = "Record is not founded"
                }
            } catch  {
                print("error")
            }
        } else {
            print("Error : memoDB open Fail, \(memoDB.lastError())")
        }
    }
}
