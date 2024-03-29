//
//  HRListViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 20/11/2018.
//  Copyright © 2018 양혜리. All rights reserved.
//

import UIKit
import SnapKit

class HRListViewController: BaseViewController {
    private lazy var memoView: UITableView = UITableView()
    private let listId: String = "HRListCell"
    private let emptyId: String = "HREmptyCell"
    private var databasePath = String()
    private var isSearched: Bool = false
    var memoList: [[String:Any]] = [[String:Any]]()
    var searchList: [[String:Any]] = [[String:Any]]()
    var tableViewInsetTop: CGFloat = 0.0
    
    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = UIColor.contentColor
        label.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var writeButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.backgroundColor = .clear
        button.layer.shadowColor = UIColor.gray.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        button.layer.shadowOpacity = 1.0
        button.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "plus"), for: .highlighted)
        button.addTarget(self, action: #selector(pressedWriteView), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboard()
        
        view.backgroundColor = .white
        memoView.backgroundColor = .contentColor
        memoView.separatorStyle = .none
        navigationController?.navigationBar.backgroundColor = .clear
 
        navigationBar.leftButton.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
        navigationBar.rightButton.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        navigationBar.bottomSearchView.textField.delegate = self
        navigationBar.bottomSearchView.textField.addTarget(self, action: #selector(changedTextFromTextField(_:)), for: .editingChanged)
        navigationBar.bottomSearchView.leftButton.isEnabled = false
        navigationBar.scrollView.isScrollEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(didShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.addSubview(memoView)
        memoView.register(HRListCell.self, forCellReuseIdentifier: listId)
        memoView.register(HREmptyCell.self, forCellReuseIdentifier: emptyId)

        memoView.keyboardDismissMode = .onDrag
        memoView.delegate = self
        memoView.dataSource = self
        
        memoView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
        }
        
        writeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-20.0)
            $0.bottom.equalToSuperview().offset(-100.0)
            $0.width.height.equalTo(50.0)
        }
        
        let fileMgr = FileManager.default
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        
        databasePath = docsDir.appending("/memo.db")
        let memoDB = FMDatabase(path: databasePath)
        if !fileMgr.fileExists(atPath: databasePath) {
            if memoDB.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS MEMO ( ID INTEGER PRIMARY KEY AUTOINCREMENT, CONTENT TEXT, DATE DATETIME, TEMPT BOOL DEFAULT FALSE )"
                if !memoDB.executeStatements(sql_stmt){
                }
                memoDB.close()
            } else {
            }
        } else {
        }
        memoDB.close()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        guard isSearched else {
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
                    }
                } catch  {
                }
            } else {
            }
            memoDB.close()
            memoView.reloadData()
            
            return
        }
    }
    
    override func pressLeftButton(_ sender: UIButton) {
        let settingViewController = HRSettingViewController()
        let navigationController = UINavigationController(rootViewController: settingViewController)
        present(navigationController, animated: true)
    }
    
    override func pressRightButton(_ sender: UIButton) {
        isSearched = true
        navigationBar.bottomSearchView.textField.becomeFirstResponder()
        memoView.reloadData()
        navigationBar.scrollView.scrollToBottom()
    }
    
    override func pressBottomRightButton(_ sender: UIButton) {
        isSearched = false
        navigationBar.bottomSearchView.textField.resignFirstResponder()
        navigationBar.bottomSearchView.textField.text = ""
        searchList.removeAll()
        memoView.reloadData()
        navigationBar.scrollView.scrollToTop()
    }
    
    @objc func pressedWriteView(_ sender: UIButton) {
        let writeVC = HRWriteViewController()
        navigationController?.pushViewController(writeVC, animated: true)
    }
    
    @objc func didShow(notification: Notification)
     {
        if navigationBar.bottomSearchView.textField.text?.isEmpty ?? true {
            guard let info = notification.userInfo else { return }
            guard let frameInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            let keyboardFrame = frameInfo.cgRectValue
            let contentHeight = memoView.frame.height - memoView.frame.origin.y - keyboardFrame.height
            tableViewInsetTop = -(contentHeight / 2.0)
            memoView.contentInset.top = tableViewInsetTop
        }
     }

     @objc func didHide(notification: Notification)
     {
        UIView.animate(withDuration: 0.5, animations: {
            self.memoView.contentInset.top = 0
        })
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
        if isSearched {
            return searchList.count > 0 ? searchList.count : 1
        }
        return memoList.count > 0 ? memoList.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if memoList.isEmpty && !isSearched {
            let cell: HREmptyCell = memoView.dequeueReusableCell(withIdentifier: emptyId, for: indexPath) as! HREmptyCell
            cell.content = "기록이 아직 없네요\n잊지 않게 메모를 시작해보아요:)"
            cell.selectionStyle = .none
            return cell
        }
        
        if searchList.isEmpty && isSearched {
            let cell: HREmptyCell = memoView.dequeueReusableCell(withIdentifier: emptyId, for: indexPath) as! HREmptyCell
            cell.content = "검색된 메모가 없어요"
            cell.selectionStyle = .none
            return cell
        }
        let dataList: [[String:Any]]
        if searchList.isEmpty {
            dataList = memoList
        } else {
            dataList = searchList
        }
        
        let cell:HRListCell = memoView.dequeueReusableCell(withIdentifier: listId, for: indexPath) as! HRListCell
        if let contentString = dataList[indexPath.row]["CONTENT"] as? String {
            cell.contentLabel.text = contentString
        }
        if let date = dataList[indexPath.row]["DATE"] as? String {
            let memoDate = stringToDate(date)
            cell.dateLabel.text = passedNumberOfDaysFromMemoDate(memoDate: memoDate)
            
        }
        return cell
    }
}

extension HRListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let status: (Bool, Bool) = (memoList.isEmpty, searchList.isEmpty)

        switch status {
        case (true, true):
            return
        case (false, true):
            if isSearched {
                break
            }
            let writeVC = HRWriteViewController()
            writeVC.memoData = memoList[indexPath.row]
            navigationController?.pushViewController(writeVC, animated: true)
            return
        case (_, false):
            let writeVC = HRWriteViewController()
            writeVC.memoData = searchList[indexPath.row]
            navigationController?.pushViewController(writeVC, animated: true)
            
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard
            !isSearched,
            !memoList.isEmpty else {
            return nil
        }
        let shareAction = UIContextualAction(style: .normal, title:  "공유", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let contentString = self.memoList[indexPath.row]["CONTENT"] as? String else {
                return
            }
            let textShare = [contentString]
            let activityVC = UIActivityViewController(activityItems: textShare, applicationActivities: nil)
            self.present(activityVC, animated: true, completion: nil)
            success(true)
        })
        
        return UISwipeActionsConfiguration(actions:[shareAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard
            !isSearched,
            !memoList.isEmpty else {
            return nil
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title:  "삭제", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let isAlert = UserDefaults.standard.bool(forKey: "alertStatus")
            if isAlert {
                self.presentAlertViewController(row: indexPath.row)
            } else {
                self.deleteDataFromList(row: indexPath.row)
            }
            success(true)
        })
        
        return UISwipeActionsConfiguration(actions:[deleteAction])
    }
    
    private func presentAlertViewController(row: Int) {
        let alertController = UIAlertController(title: "삭제확인", message: "정말 삭제하시나요?", preferredStyle: .alert)
        let removeButton = UIAlertAction(title: "확인", style: .default) { _ in
            self.deleteDataFromList(row: row)
            alertController.dismiss(animated: true)
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel) { _ in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(removeButton)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
    
    private func deleteDataFromList(row: Int) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        self.databasePath = docsDir.appending("/memo.db")
        let memoDB = FMDatabase(path: self.databasePath)
       
        if memoDB.open(){
            let deleteSQL = "DELETE FROM MEMO WHERE ID = \(self.memoList[row]["ID"]!)"
            do {
                let result = try memoDB.executeQuery(deleteSQL, values: [])
                while(result.next()) {
                    if let element = result.resultDictionary as? [String : Any] {
                        self.memoList.append(element)
                    }
                }
               
                self.memoList.remove(at: row)
                self.memoView.reloadData()
            } catch  {
            }
        } else {
        }
        memoDB.close()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard navigationController != nil else {
            return UIScreen.main.bounds.height - view.safeAreaInsets.top - view.safeAreaInsets.bottom
        }
        
        if (memoList.isEmpty && !isSearched) || (searchList.isEmpty && isSearched) {
            return memoView.frame.size.height - view.safeAreaInsets.bottom
        }
    
        return 70.0
    }
    
    private func searchTextFromMemo(text: String) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPath[0]
        print(docsDir)
        
        self.databasePath = docsDir.appending("/memo.db")
        let memoDB = FMDatabase(path: self.databasePath)
        
        if memoDB.open(){
            let searchSQL = "SELECT * FROM MEMO WHERE CONTENT like '%\(text)%'"
            
            do {
                let result = try memoDB.executeQuery(searchSQL, values: [])
                searchList.removeAll()
                while(result.next()) {
                    if let element = result.resultDictionary as? [String : Any] {
                        searchList.append(element)
                    }
                 }
                changeContent()
            } catch  {
            }
        } else {
        }
        memoDB.close()
    }
    
    func changeContent() {
        DispatchQueue.main.async {
            if self.searchList.isEmpty {
                if self.memoView.contentOffset.y == 0.0 {
                    UIView.setAnimationsEnabled(false)
                    self.memoView.beginUpdates()
                    self.memoView.setContentOffset(.zero, animated: false)
                    self.memoView.endUpdates()
                    UIView.setAnimationsEnabled(true)
                }
              
                if self.memoView.contentInset.top == 0.0 {
                    self.memoView.contentInset.top = self.tableViewInsetTop
                }
            } else {
                self.memoView.contentInset.top = 0.0
            }
            self.memoView.layoutIfNeeded()

            }
            memoView.reloadData()
    }
    
    @objc private func changedTextFromTextField(_ textField: UITextField) {
        guard
            let text = textField.text,
                text.count > 0 else {
                    searchList.removeAll()
                    memoView.reloadData()
                    return
            }
        searchTextFromMemo(text: text)
    }
}

extension HRListViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchList.removeAll()
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
