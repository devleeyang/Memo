//
//  HRSettingViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 28/03/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit
import MessageUI

class HRSettingViewController: UIViewController {
    private var settingView = UITableView()
    private let contentId = "HRContentCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingView)
        settingView.register(HRContentCell.self, forCellReuseIdentifier: contentId)
        settingView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        settingView.delegate = self
        settingView.dataSource = self
    }
}

extension HRSettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1:
            return 1
        case 2:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HRContentCell = settingView.dequeueReusableCell(withIdentifier: contentId, for: indexPath) as! HRContentCell
        let index = (indexPath.section, indexPath.row)
        switch index {
        case (0, _):
            cell.titleLabel.text = "메모"
        case (1, _):
            cell.titleLabel.text = "일반"
        case (2, 0):
            cell.titleLabel.text = "정보"
        case (2, 1):
            cell.titleLabel.text = "버전"
        default:
            break
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

extension HRSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = (indexPath.section, indexPath.row)
        switch index {
        case (0, _):
            break
        case (1, _):
            if MFMailComposeViewController.canSendMail() {
                let mail = HRMailViewController.init(toRecipients: ["테스트1"], subject: "test2", body: "text3") {
                    print("완료")
                }
                self.present(mail!, animated: true, completion: nil)
            }
            break
        case (2, 0):
            break
        case (2, 1):
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 13)
    
        headerView.addSubview(title)
        title.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-10)
            $0.centerY.equalToSuperview()
        }
        
        switch section {
        case 0:
            title.text = "메모"
        case 1:
            title.text = "일반"
        case 2:
            title.text = "정보"
        default:
            title.text = "기타"
        }
        
        
        return headerView
    }
}
