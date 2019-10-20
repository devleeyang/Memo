//
//  HRSettingViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 28/03/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit
import MessageUI

class HRSettingViewController: BaseViewController {
    private var settingView = UITableView()
    private let arrowId = "HRRightArrowCell"
    private let textId = "HRRightTextCell"
    private let switchId = "HRRightSwitchCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.scrollView.isScrollEnabled = false
        settingView.backgroundColor = .contentColor
        view.addSubview(settingView)
        settingView.register(HRRightArrowCell.self, forCellReuseIdentifier: arrowId)
        settingView.register(HRRightTextCell.self, forCellReuseIdentifier: textId)
        settingView.register(HRRightSwitchCell.self, forCellReuseIdentifier: switchId)
        settingView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(navigationBar.snp.bottom)
        }
        settingView.delegate = self
        settingView.dataSource = self
        settingView.separatorStyle = .none
        settingView.bounces = false
        
        navigationBar.leftButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
    }
    
    override func pressLeftButton(_ sender: UIButton) {
        dismiss(animated: true)
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
        
        let index = (indexPath.section, indexPath.row)
        switch index {
        case (0, _):
            let cell: HRRightSwitchCell = settingView.dequeueReusableCell(withIdentifier: switchId, for: indexPath) as! HRRightSwitchCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "삭제 확인"
            cell.contentLable.text = "메모를 삭제할 때 한번 더 확인합니다!"
            cell.switchView.isOn = UserDefaults.standard.bool(forKey: "alertStatus")
            cell.switchView.addTarget(self, action: #selector(onClickSwitch(sender:)), for: .valueChanged)
            return cell
        case (1, _):
            let cell: HRRightArrowCell = settingView.dequeueReusableCell(withIdentifier: arrowId, for: indexPath) as! HRRightArrowCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "버그 신고 및 제안하기"
            return cell
        case (2, 0):
            let cell: HRRightTextCell = settingView.dequeueReusableCell(withIdentifier: textId, for: indexPath) as! HRRightTextCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "버전"
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                cell.contentLable.text = version
            }
            return cell
        case (2, 1):
            let cell: HRRightArrowCell = settingView.dequeueReusableCell(withIdentifier: arrowId, for: indexPath) as! HRRightArrowCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "Open Source License"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func onClickSwitch(sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "alertStatus")
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
                guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String  else {
                    return
                }
                
                let mail = HRMailViewController.init(toRecipients: ["devleeyang6424@gmail.com"], subject: "Easy Memo 버그리포트 및 제안하기", body: "\n\n\n --- \n iOS \(UIDevice.current.systemVersion) / iPhone / 메모 \(version)") {
                    print("완료")
                }
                self.present(mail!, animated: true, completion: nil)
            }
            break
        case (2, 0):
            break
        case (2, 1):
            let openViewController = HROpenSourceViewController()
            navigationController?.pushViewController(openViewController, animated: false)
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
        title.textColor = .contentTextColor
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
