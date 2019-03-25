//
//  HRListViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 20/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit
import SnapKit

class HRListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var memoView = UITableView()
    private let listId = "HRListCell"
    private var databasePath = String()
    var memoList = Array<Dictionary<String, Any>>()
    
    private let addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(#imageLiteral(resourceName: "search"), for: .normal)
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 21)
//        label.textAlignment = .center
//        label.text = "유저정보를 가져오는 중입니다.\n잠시만 기다려주시길 바랍니다."
//        label.numberOfLines = 0
        
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        memoView = UITableView()
        view.addSubview(memoView)
        memoView.backgroundColor = UIColor(red:224.0/255.0, green:218.0/255.0, blue:245.0/255.0, alpha:1.0)
        memoView.register(HRListCell.self, forCellReuseIdentifier: listId)
        memoView.keyboardDismissMode = .onDrag
        
        memoView.delegate = self
        memoView.dataSource = self

        memoView.addSubview(addButton)
        
        memoView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
//        addButton.snp.makeConstraints {
//              $0.leading.trailing.top.bottom.equalToSuperview().offset(10)
//        }
        
        
        
        let fileMgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        print(docsDir)
        
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
        memoList.removeAll()
        // 파일 찾기, 유저 홈 위치
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        // Document 경로
        let docsDir = dirPath[0]
        print(docsDir)
        
        // Document/contacts.db라는 경로(커스터마이징 db임)
        databasePath = docsDir.appending("/memo.db")
        
        let memoDB = FMDatabase(path: databasePath)
        
        if memoDB.open(){
            let selectSQL = "SELECT * FROM MEMO ORDER BY DATE DESC"
            print(selectSQL)
            do {
                let result = try memoDB.executeQuery(selectSQL, values: [])
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
        let cell:HRListCell = memoView.dequeueReusableCell(withIdentifier: listId, for: indexPath) as! HRListCell
        if let contentString = memoList[indexPath.row]["CONTENT"] as? String {
            cell.contentLabel.text = contentString
        }
        if let date = memoList[indexPath.row]["DATE"] as? String {
            let memoDate = stringToDate(date)
            cell.dateLabel.text = passedNumberOfDaysFromMemoDate(memoDate: memoDate)

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let writeVC = storyboard.instantiateViewController(withIdentifier:"HRWriteViewController" ) as? HRWriteViewController {
            writeVC.memoData = memoList[indexPath.row]
            self.navigationController?.pushViewController(writeVC, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title:  "공유", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            let text = "공유할 내용"
            let textShare = [text]
            let activityVC = UIActivityViewController(activityItems: textShare, applicationActivities: nil)
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop]
            self.present(activityVC, animated: true, completion: nil)
            
        })
        
        return UISwipeActionsConfiguration(actions:[shareAction])
    }
    /*
    func tableView(_ tableView: UITableView,   indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            // Document 경로
            let docsDir = dirPath[0]
            print(docsDir)
//            [tableView beginUpdates];
//            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [tableView endUpdates];
            self.memoView.beginUpdates()
//            self.memoView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic, with:  )
            self.memoView.deleteRows(at: [indexPath], with: UITableView.R)
            self.memoView.endUpdates()
            /*
            // Document/contacts.db라는 경로(커스터마이징 db임)
            self.databasePath = docsDir.appending("/memo.db")
            
            let memoDB = FMDatabase(path: self.databasePath)
            
            if memoDB.open(){
                let deleteSQL = "DELETE FROM MEMO WHERE ID = \(self.memoList[indexPath.row]["ID"]!)"
                print(deleteSQL)
                do {
                    let result = try memoDB.executeQuery(deleteSQL, values: [])
                    while(result.next()) {
                        if let element = result.resultDictionary as? [String : Any] {
                            self.memoList.append(element)
                        }
                        print("result.resultDictionary : \(String(describing: result.resultDictionary))")
                    }
                    self.memoList.remove(at: indexPath.row)
//                    self.memoView.reloadData()
                } catch  {
                    print("error")
                }
            } else {
                print("Error : memoDB open Fail, \(memoDB.lastError())")
            }
            memoDB.close()
             */
        })
        
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
 
 */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            // Document 경로
            let docsDir = dirPath[0]
            print(docsDir)
            //            [tableView beginUpdates];
            //            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            //            [tableView endUpdates]

            self.databasePath = docsDir.appending("/memo.db")
            let memoDB = FMDatabase(path: self.databasePath)

            if memoDB.open(){
                let deleteSQL = "DELETE FROM MEMO WHERE ID = \(self.memoList[indexPath.row]["ID"]!)"
                print(deleteSQL)
                
                do {

                    let result = try memoDB.executeQuery(deleteSQL, values: [])

                    while(result.next()) {

                        if let element = result.resultDictionary as? [String : Any] {

                            self.memoList.append(element)

                        }

                        print("result.resultDictionary : \(String(describing: result.resultDictionary))")

                    }

                    self.memoList.remove(at: indexPath.row)
                 
                    self.memoView.reloadData()

                } catch  {

                    print("error")

                }

            } else {

                print("Error : memoDB open Fail, \(memoDB.lastError())")

            }

            memoDB.close()


            success(true)
            
        })
        
        return UISwipeActionsConfiguration(actions:[deleteAction])
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
    
    func passedNumberOfDaysFromMemoDate(memoDate:Date) -> String {
    
        /*
         타임초를 비교했는데 하루보다 작으면 -> day를 비교후 day차가 발생하면 1일전, 아니면 시간으로 나타냄
         시간은 초는 초 / 분/ 시간으로 변경
         나머지 day는 day로 하고, 한달이상 차이 날 시... 달로 변경 달은 30일 기준
         */
        let subtract = Int(Date().timeIntervalSince1970) - Int(memoDate.timeIntervalSince1970)
        let quotient = subtract/(60*60*24)
        let cal = Calendar.current
 
        if (quotient == 0) {
            let memoDay = cal.component(.day, from: memoDate)
            let toDay = cal.component(.day, from: Date())
            if (toDay - memoDay > 0) {
                return "약 1일 전"
            } else {
                //                if (subtract/60*60)
                let hour = subtract/(60*60)
                if (hour > 0) {
                    return "약 \(hour)시간 전"
                } else {
                    let min = subtract/60
                    if (min > 0) {
                        return "약 \(min)분 전"
                    } else {
                        if (subtract == 0) {
                            return "방금 전"
                        } else {
                            return "약 \(subtract)초 전"
                        }
                    }
                }
            }
        } else {
            if (quotient < 30) {
                return "약 \(quotient)일 전"
            } else {
                let month = subtract/(60*60*24*30)
                if (month < 12) {
                    return "약 \(month)달 전"
                } else {
                    let year = subtract/(60*60*24*30*12)
                    return "약 \(year)년 전"
                }
            }
        }
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
