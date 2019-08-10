//
//  HeartRateVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 15/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class HeartRateVC: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var enterHeartRate: UITextField!
    @IBOutlet weak var currentHeartRateValue: UILabel!
    @IBOutlet weak var updatedDate: UILabel!
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var alertHigh: UILabel!
    @IBOutlet weak var alertLow: UILabel!
    @IBOutlet weak var doctorNotes: UILabel!
    
    var heartRate: [NSManagedObject] = []
    let currentdate = NSDate()
    var UHI = String()
    
    var h = ""
    var d = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        print(currentdate)
        
        currentHeartRateValue.text = h
        let dateComponents = d.components(separatedBy: " ")
        if (dateComponents.count > 1){
            updatedDate.text = "\(dateComponents[0]) \(dateComponents[1])"
        }else{
            updatedDate.text = "No Data"
        }
        
        fetchDoctorsInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDoctorsInfo()
    }
    var high = 0
    var low = 0
    var goalv = 0
    var note = ""
    
    func fetchDoctorsInfo(){
        UHI = UserDefaults.standard.object(forKey: "UHI") as! String
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequestHeartRate =
            NSFetchRequest<NSManagedObject>(entityName: "HeartRateInfo")
        do{
            let heartRateInfo = try managedContext.fetch(fetchRequestHeartRate)
            for heartData in heartRateInfo{
                if (UHI == heartData.value(forKey: "patientID") as? String){
                    goalv = heartData.value(forKey: "goal") as? Int ?? 0
                    if (goalv > 0){
                         goal.text = "\(goalv) bpm"
                    }
                    let l = heartData.value(forKey: "alert_low") as? Int ?? 0
                    if (l > 0){
                        low = l
                        alertLow.text = "\(low) bpm"
                    }
                    let h = heartData.value(forKey: "alert_high") as? Int ?? 0
                    if (h > 0){
                        high = h
                        alertHigh.text = "\(high) bpm"
                    }
                    note = heartData.value(forKey: "doctor_notes") as? String ?? ""
                    if (note != ""){
                        doctorNotes.text = note
                    }
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonitorDashboardVC") as! MonitorDashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Checking if the entered values with the alert values if they are abnormal then email to both Doctor as well as to the guardian.
     Note: Apple do not allow you to send emails in the background without user's interaction. The only way you can do this is to use a server to send the email.
     */
    func checkforAbnormalValues(){
        if let eneteredValue = Int(enterHeartRate.text!){
            if (Int(eneteredValue) >= high || Int(eneteredValue) <= low){
                let doctorsEmail = UserDefaults.standard.object(forKey: "doctorsEmail") as! String
                let emergencyEmail = UserDefaults.standard.object(forKey: "EmergencyConatctEmail") as! String
                
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([doctorsEmail, emergencyEmail])
                    mail.setSubject("Alert !!!")
                    mail.setMessageBody("<h3>Please take care of your dear one, as heart rate values has been recorded abnormally !!! </h3>", isHTML: true)
                    present(mail, animated: true)
                } else {
                    let alert = UIAlertController(title: "Unable to send", message: "Please check your internet and also correct recipitents email address", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                return
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
      
        // for the first time
        if(enterHeartRate.text != ""){
            checkforAbnormalValues()
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "HeartRateInfo",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
            
            person.setValue(uhi, forKey: "patientID")
            person.setValue(Int16(enterHeartRate.text!), forKey: "heartrate_value")
            person.setValue(NSDate(), forKey: "date")
            person.setValue("bpm", forKey: "unit")
            
            person.setValue(note, forKey: "doctor_notes")
            person.setValue(goalv, forKey: "goal")
            person.setValue(high, forKey: "alert_high")
            person.setValue(low, forKey: "alert_low")
            
            do {
                try managedContext.save()
                heartRate.append(person)
                
                let rate = enterHeartRate.text!
                currentHeartRateValue.text = rate
                let date = "\(currentdate)"
                let displayDate = date.components(separatedBy: " ")
                updatedDate.text = displayDate[0]
                
                enterHeartRate.text = ""
                
                let alert = UIAlertController(title: "Saved", message: "Your Heartrate values have been saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
}
