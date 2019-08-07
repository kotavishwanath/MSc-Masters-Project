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

        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let countw = times.count
        message = "Hi, <br><br>Please send the below prescribed medicines to our home address which is at the bottom of this email.<br><br>"
        message += "<h3><b> Medicines List </b></h3>"
        var i = 1
        for x in 0..<countw{
            let name = medidinename[x] as! String
            let timesx = times[x] as! Int
            let daysx = days[x] as! Int
//            message += "<br>"
            message += "<p>\(i)) \(name) ------ \(timesx * daysx) tablets</p>"
            i+=1
        }
        message += "<br><br><br><br>"
        message += "<h3><b>Delivery address: </b></h3>"
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")
        var name = ""
        do {
            let patientInfo = try managedContext.fetch(fetchRequest)
            for data in patientInfo{
                if ((data.value(forKey: "uhi") as! Int ) == Int(uhi)){
                    name = data.value(forKey: "display_name") as! String
                    let address = data.value(forKey: "address") as! String
                    let postcode = data.value(forKey: "postcode") as! String
                    let country = data.value(forKey: "country") as! String
                    message += "\(name) <br>"
                    message += "\(address) <br>"
                    message += "\(postcode) <br>"
                    message += "\(country) <br>"
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        message += "<br><br><br>"
        message += "Thanks, <br>"
        message += "\(name).<br>"
        
        print(message)
 
        //Send the address of the patient to pharma
    }

    func sendEmail() {
        if (emailAddressTxt.text == "" || emailAddressTxt.text == nil){
            showAlert(msg: "email address to send the prescription")
            return
        }
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailAddressTxt.text!])
            mail.setSubject("Please send all the medicines")
            mail.setMessageBody(message, isHTML: true)
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
        sendEmail()
    }
    
    @IBAction func callPharmaBtn(_ sender: Any) {
        if (telephoneNum.text == "" || telephoneNum.text == nil){
           showAlert(msg: "number to dial")
           return
        }
        guard let number = URL(string: "tel://" + telephoneNum.text!) else { return }
        UIApplication.shared.open(number)
        /*
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Calling to \(pharmaName.text!)"
            controller.recipients = [telephoneNum.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
         */
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func showAlert(msg: String){
        let alert = UIAlertController(title: "Unavailable", message: "You haven't given any \(msg)", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
