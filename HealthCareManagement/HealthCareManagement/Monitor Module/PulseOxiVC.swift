//
//  PulseOxiVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 14/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
/**
 This class is used for updating the PulseOxi information by the registered patient
 */
class PulseOxiVC: UIViewController, MFMailComposeViewControllerDelegate {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var currentOxiValue: UILabel!
    @IBOutlet weak var updatedDate: UILabel!
    @IBOutlet weak var oxiGoal: UILabel!
    @IBOutlet weak var enterOxiValue: UITextField!
    @IBOutlet weak var doctorsNotes: UILabel!
    @IBOutlet weak var alertLow: UILabel!
    
    var pulseOxi: [NSManagedObject] = []
    let currentdate = NSDate()
    var UHI = String()
    
    var p = ""
    var d = ""
    
    var low = -1.0
    var goal = -1.0
    var note = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        currentOxiValue.text = p
        let dateComponents = d.components(separatedBy: " ")
        if (dateComponents.count > 1){
             updatedDate.text = "\(dateComponents[0]) \(dateComponents[1])"
        }else{
             updatedDate.text = "No Data"
        }
        
        fetchDoctorsInfo()
    }
    /**
     View Controller life cycle method, it is called when navigated back to this screen
     */
    override func viewWillAppear(_ animated: Bool) {
        fetchDoctorsInfo()
    }
    /**
     Fetching the doctor inputs like alerts and notes
     */
    func fetchDoctorsInfo(){
        UHI = UserDefaults.standard.object(forKey: "UHI") as! String
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequestPulseOxi =
            NSFetchRequest<NSManagedObject>(entityName: "PulseOxiInfo")
        do{
            let pluseOxiInfo = try managedContext.fetch(fetchRequestPulseOxi)
            for pulseData in pluseOxiInfo{
                if (UHI == pulseData.value(forKey: "patientID") as? String){
                    goal = Double(pulseData.value(forKey: "goal") as? Float ?? 0.0)
                    if (goal > 0){
                         oxiGoal.text = String(format: "%.1f %%", goal)
                    }
                    let l = Double(pulseData.value(forKey: "alert_low_pulse") as? Float ?? 0.0)
                    if (l > 0){
                        low = l
                        alertLow.text = String(format: "%.1f %%", low)
                    }
                    note = pulseData.value(forKey: "doctor_notes") as? String ?? ""
                    if (note != ""){
                         doctorsNotes.text = note
                    }
                    
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    /**
     Back button which will navigate to Monitor Dahborad screen
     */
    @IBAction func backButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonitorDashboardVC") as! MonitorDashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    /**
     Checking if the entered values with the alert values if they are abnormal then email to both Doctor as well as to the guardian.
     Note: Apple do not allow you to send emails in the background without user's interaction. The only way you can do this is to use a server to send the email.
     */
    func checkforAbnormalValues(){
        if let eneteredValue = Int(enterOxiValue.text!){
            if (low < 0){
                return
            }
            if (Double(eneteredValue) <= low){
                let doctorsEmail = UserDefaults.standard.object(forKey: "doctorsEmail") as! String
                let emergencyEmail = UserDefaults.standard.object(forKey: "EmergencyConatctEmail") as! String
                
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([doctorsEmail, emergencyEmail])
                    mail.setSubject("Alert !!!")
                    mail.setMessageBody("<h3>Please take care of your dear one, as Pulse oxi values has been recorded abnormally !!! </h3>", isHTML: true)
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
    ///MARK:- Mail composser delegate method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    /**
     Save button used for saving the vital information
     */
    @IBAction func saveButtonClicked(_ sender: Any) {
        if(enterOxiValue.text != ""){
            checkforAbnormalValues()
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "PulseOxiInfo",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
            
            person.setValue(uhi, forKey: "patientID")
            person.setValue(Float(enterOxiValue.text!), forKey: "pulseoxi_value")
            person.setValue(NSDate(), forKey: "date")
            person.setValue("%", forKey: "unit")
            
            person.setValue(note, forKey: "doctor_notes")
            person.setValue(goal, forKey: "goal")
            person.setValue(low, forKey: "alert_low_pulse")
            
            do {
                try managedContext.save()
                pulseOxi.append(person)
                
                let oxiValue = enterOxiValue.text!
                currentOxiValue.text = oxiValue
                let date = "\(currentdate)"
                let displayDate = date.components(separatedBy: " ")
                updatedDate.text = displayDate[0]
                
                enterOxiValue.text = ""
                
                let alert = UIAlertController(title: "Saved", message: "Your pulse oximeter values have been saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        
    }
    
}
