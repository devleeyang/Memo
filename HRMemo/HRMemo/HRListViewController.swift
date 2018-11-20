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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memoView.register(UINib(nibName: "HRListCell", bundle: nil), forCellReuseIdentifier: "HRListCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return responseList.count > 0 ? responseList.count : 0
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:HRListCell = memoView.dequeueReusableCell(withIdentifier: "HRListCell") as! HRListCell
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
    
}
