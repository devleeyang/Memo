//
//  HRListViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 20/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit

class HRListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var memoView: UITableView!
    var databasePath = String()
    var memoList = Array<Dictionary<String, Any>>()

    override func viewDidLoad() {
        super.viewDidLoad()
        memoView.register(UINib(nibName: "HRListCell", bundle: nil), forCellReuseIdentifier: "HRListCell")
        // Do any additional setup after loading the view, typically from a nib. // DB Check
        
        let fileMgr = FileManager.default
        // 파일 찾기, 유저 홈 위치
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Document 경로
        let docsDir = dirPath[0]
        print(docsDir)
        
        // Document/contacts.db라는 경로(커스터마이징 db임)
        databasePath = docsDir.appending("/memo.db")
        
        let memoDB = FMDatabase(path: databasePath)
        
        if !fileMgr.fileExists(atPath: databasePath) {
            // DB 접속
            if memoDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS MEMO ( ID INTEGER PRIMARY KEY AUTOINCREMENT, CONTENT TEXT, DATE DATETIME, TEMPT BOOL DEFAULT FALSE )"
                if !memoDB.executeStatements(sql_stmt){
                    print("Error : memoDB execute Fail, \(memoDB.lastError())")
                }
                memoDB.close()
                
            } else {
                print("Error : memoDB open Fail, \(memoDB.lastError())")
            }
        } else {
            print("memoDB is exist")
            /*
            if memoDB.open(){
                let insertSQL = "INSERT INTO MEMO (CONTENT, DATE, TEMPT) values ('우주', DATETIME('now', 'localtime'), FALSE)"
                print(insertSQL)
                let result = memoDB.executeUpdate(insertSQL, withArgumentsIn: [])
                if !result{
                    print("Error : memoDB add Fail, \(memoDB.lastError())")
                } else {
                }
            } else {
                print("Error : memoDB open Fail, \(memoDB.lastError())")
            }
*/
            
            /*
            if memoDB.open(){
                let insertSQL = "DELETE FROM MEMO WHERE ID = 2 "
                print(insertSQL)
                let result = memoDB.executeUpdate(insertSQL, withArgumentsIn: [])
                if !result{
                    print("Error : memoDB add Fail, \(memoDB.lastError())")
                } else {
                }
            } else {
                print("Error : memoDB open Fail, \(memoDB.lastError())")
            }
 */
            
        }
        memoDB.close()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let fileMgr = FileManager.default
        // 파일 찾기, 유저 홈 위치
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Document 경로
        let docsDir = dirPath[0]
        print(docsDir)
        
        // Document/contacts.db라는 경로(커스터마이징 db임)
        databasePath = docsDir.appending("/memo.db")
        
        let memoDB = FMDatabase(path: databasePath)
        
        if memoDB.open(){
            let selectSQL = "SELECT * FROM MEMO"
            print(selectSQL)
            do {
                let result = try memoDB.executeQuery(selectSQL, values: [])
                memoList.removeAll()
                while(result.next()) {
                    if let element = result.resultDictionary as? [String : Any] {
                        memoList.append(element)
                    }
                    print("result.resultDictionary : \(String(describing: result.resultDictionary))")
                }
            } catch  {
                print("error")
            }
        } else {
            print("Error : memoDB open Fail, \(memoDB.lastError())")
        }
        memoDB.close()
        memoView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count > 0 ? memoList.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HRListCell = memoView.dequeueReusableCell(withIdentifier: "HRListCell") as! HRListCell
        if let contentString = memoList[indexPath.row]["CONTENT"] as? String {
            cell.contentLabel.text = contentString
        }
        if let date = memoList[indexPath.row]["DATE"] as? String {
            let memoDate = stringToDate(date)
//            stringToDate(ㅇ)
            let date = Date()
            let test = date.timeIntervalSince1970 - memoDate.timeIntervalSince1970
//            let test = date.timeIntervalSince(memoDate)
            print("memoDae : \(memoDate) , date : \(date), test : \(test)")
//            var dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            let dateString1 = dateFormatter.string(from: date)
//            let nowString = stringToDate(dateString1)
            
//            Date(from: Decoder())
//            let calendar = Calendar.current
//            let time=calendar.dateComponents([.hour,.minute,.second], from: Date())
//
//            let dateFormatters:DateFormatter = DateFormatter()
//            dateFormatters.dateFormat = "yyyy-MM-dd HH:mm:ss"
//            dateFormatters.timeZone = TimeZone(secondsFromGMT: 9)
//            dateFormatters.locale = Locale(identifier: "ko_KR")
//            dateFormatters.locale = Locale.current
//            let date: Date = Date(from: Decoder(timezone(9)))
//            print("Current Date : \(date)")
//            print("Format Date as you want : \(dateFormatters.string(from: date))")
//            let currentTimeZone = getCurrentTimeZone()
//            print("dateString :\(dateString) \t nowString :\(nowString)")
            
//            print(time)

        }

        return cell
//        if (indexPath.row < 2) {
//            let cell:THLabelCell = helloView.dequeueReusableCell(withIdentifier: "THLabelCell") as! THLabelCell
//            cell.title.text = "#\(responseList[indexPath.row].number) : \(responseList[indexPath.row].title)"
//            return cell
//        } else if indexPath.row == 2 {
//            let cell:THImageCell = helloView.dequeueReusableCell(withIdentifier: "THImageCell") as! THImageCell
//            let url = URL(string: "https://s3.ap-northeast-2.amazonaws.com/hellobot-kr-test/image/main_logo.png")
//            cell.hellImg.kf.setImage(with: url)
//            return cell
//        } else {
//            let cell:THLabelCell = helloView.dequeueReusableCell(withIdentifier: "THLabelCell") as! THLabelCell
//            cell.title.text = "#\(responseList[indexPath.row-1].number) : \(responseList[indexPath.row-1].title)"
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let writeVC = storyboard.instantiateViewController(withIdentifier:"HRWriteViewController" ) as? HRWriteViewController {
            writeVC.memoData = memoList[indexPath.row]
            self.navigationController?.pushViewController(writeVC, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    @IBAction func pressedWriteView(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let writeVC = storyboard.instantiateViewController(withIdentifier:"HRWriteViewController" ) as? HRWriteViewController {
            self.navigationController?.pushViewController(writeVC, animated: true)
        }
    }
    
    func stringToDate(_ str: String)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: getCurrentTimeZone()/3600)
//        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: str)!
    }
    
    func dateToString(_ str: Date)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle=DateFormatter.Style.short
        return dateFormatter.string(from: str)
    }
    
    func getCurrentTimeZone() -> Int{
        
        return TimeZone.current.secondsFromGMT()
        
    }
    
   /*
    func parseDate(questionDate: String) -> Date? {
        // parse "1900-00-00T12:34:56.0000Z" format
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSxxx"
        let date = dateFormatter.date(from: questionDate)
        return date
    }
    
    func getDateFormat() -> String? {
        let date = parseDate(questionDate: updatedAt!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
        
        return dateFormatter.string(from: date!)
    }
     */
    
}
