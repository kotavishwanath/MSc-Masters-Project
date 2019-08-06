//
//  TeleMedicineVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 05/08/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

class TeleMedicineVC: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    @IBOutlet weak var pharmaName: UITextField!
    @IBOutlet weak var pharmaAddress1: UITextField!
    @IBOutlet weak var pharmaAddress2: UITextField!
    @IBOutlet weak var postcodeTxt: UITextField!
    @IBOutlet weak var telephoneNum: UITextField!
    @IBOutlet weak var emailAddressTxt: UITextField!
    
    @IBOutlet weak var sendPresctionBtn: UIButton!
    @IBOutlet weak var callPharmaBtn: UIButton!
    
    var message = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TimesADay HowManyDays MedicineNamesList
        let medidinename = UserDefaults.standard.object(forKey: "MedicineNamesList") as! NSArray
        let times = UserDefaults.standard.object(forKey: "TimesADay") as! NSArray
        let days = UserDefaults.standard.object(forKey: "HowManyDays") as! NSArray
//        let li = UserDefaults.standard.object(forKey: "List") as! NSArray
     
//        for i in li{
//            print(i)
//        }
//
//        let res = zip(times, days).map { $0 * $1 }
        
        let countw = times.count
        
        for x in 0..<countw{
                let name = medidinename[x] as! String
                let timesx = times[x] as! Int
                let daysx = days[x] as! Int
                message = "<br>"
                message += "<p>\(name) ------ \(timesx * daysx) tablets</p>"
        }
        print(message)
 
        
        message = "<p>Hi, <br> Your second sentence would begin on the next line.</p>"
        //Send the address of the patient to pharma
    }

    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailAddressTxt.text!])
            mail.setSubject("Please send all the medicines")
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
            let alert = UIAlertController(title: "Unable to send", message: "Please check your internet and also correct recipitents email address", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

    @IBAction func back(_ sender: Any) {
        let name = UserDefaults.standard.object(forKey: "username") as! String
        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = uhi
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func sendPrescriptionBtn(_ sender: Any) {
        
    }
    
    @IBAction func callPharmaBtn(_ sender: Any) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Message Body"
            controller.recipients = [telephoneNum.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}
