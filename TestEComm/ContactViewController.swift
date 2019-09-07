//
//  ContactViewController.swift
//  TestEComm
//
//  Created by Tushar Indi on 06/09/19.
//  Copyright © 2019 Tushar Indi. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class ContactViewContorller: UIViewController, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var txtName : UITextField!
    @IBOutlet weak var txtMessage : UITextView!
    
    @IBAction func btnBackPressed() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSendPressed() {
        let emailTitle = "Ad Enquiry"
        let messageBody = "Enquirer Name : " + txtName.text! + "\n\n" + txtMessage.text!
        let toRecipents = ["developer@aigen.tech"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipents)
        
        if (mc != nil) {
            self.present(mc, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
}
