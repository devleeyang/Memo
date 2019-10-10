//
//  HRListViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 20/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit
import SnapKit

class HRListViewController: BaseViewController, UISearchBarDelegate, UISearchResultsUpdating {
    private lazy var memoView = UITableView()
    private let listId = "HRListCell"
    private var databasePath = String()
    private let searchController = UISearchController(searchResultsController: nil)
    var memoList = Array<Dictionary<String, Any>>()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setTitle("+", for: .normal)
        button.setTitle("+", for: .selected)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 29)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white, for: .selected)
        button.backgroundColor = .blue
        button.layer.cornerRadius = button.bounds.size.width / 2
        button.addTarget(self, action: #selector(pressedWriteView), for: .touchUpInside)
        
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.backgroundColor = .clear
        navi.leftButton.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
        navi.rightButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        
        view.addSubview(memoView)
        view.addSubview(addButton)
        memoView.backgroundColor = UIColor(red:224.0/255.0, green:218.0/255.0, blue:245.0/255.0, alpha:1.0)
        memoView.register(HRListCell.self, forCellReuseIdentifier: listId)
        memoView.keyboardDismissMode = .onDrag
        memoView.delegate = self
        memoView.dataSource = self
        
        memoView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navi.snp.bottom)
        }
        
        addButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().offset(-30)
            $0.size.width.height.equalTo(50)
        }
        
        let fileMgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        print(docsDir)
        
        databasePath = docsDir.appending("/memo.db")
        let memoDB = FMDatabase(path: databasePath)
        if !fileMgr.fileExists(atPath: databasePath) {
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
        }
        memoDB.close()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        memoList.removeAll()
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        print(docsDir)
        
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
    
    override func pressLeftButton(_ sender: UIButton) {
        let settingVC = HRSettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    override func pressRightButton(_ sender: UIButton) {
        
    }
    
    @objc func pressedWriteView(_ sender: UIButton) {
        let writeVC = HRWriteViewController()
        navigationController?.pushViewController(writeVC, animated: true)
    }
    
    @objc func searchInputText(_ sender: UIButton) {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Candies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    @objc func pressedSetting(_ sender: UIButton) {
        let settingVC = HRSettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func stringToDate(_ str: String)->Date{
        let formatter = DateFormatter()
        formatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: getCurrentTimeZone()/3600)
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
}

extension HRListViewController: UITableViewDataSource {
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
}

extension HRListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let writeVC = HRWriteViewController()
        writeVC.memoData = memoList[indexPath.row]
        navigationController?.pushViewController(writeVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title:  "공유", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            success(true)
            let text = "공유할 내용"
            let textShare = [text]
            let activityVC = UIActivityViewController(activityItems: textShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            
        })
        
        return UISwipeActionsConfiguration(actions:[shareAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            let docsDir = dirPath[0]
            print(docsDir)
            
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
}
