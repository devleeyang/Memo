//
//  HRMailViewController.swift
//  HRMemo
//
//  Created by 양혜리 on 28/03/2019.
//  Copyright © 2019 양혜리. All rights reserved.
//

import UIKit
import MessageUI

class HRMailViewController: MFMailComposeViewController {
    private let completion: () -> Void
    
    init?(toRecipients: [String], subject: String, body: String, completion: @escaping () -> Void) {
        guard MFMailComposeViewController.canSendMail() else { return nil }
        
        self.completion = completion
        super.init(nibName: nil, bundle: nil)
        
        mailComposeDelegate = self
        setToRecipients(toRecipients)
        setSubject(subject)
        setMessageBody(body, isHTML: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
extension HRMailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true) { self.completion() }
    }
}
