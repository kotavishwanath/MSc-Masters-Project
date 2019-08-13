//
//  GlucoseVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 14/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
/**
 This class is used for updating the Glucose levels information by the registered patient
 */
class GlucoseVC: UIViewController, MFMailComposeViewControllerDelegate {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var currentGlucoseValue: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    @IBOutlet weak var glucoseGoal: UILabel!
    @IBOutlet weak var enterGlucoseValue: UITextField!
    @IBOutlet weak var alertHighValue: UILabel!
    @IBOutlet weak var alertLowValue: UILabel!
    @IBOutlet weak var doctorNotes: UILabel!
    
    var glucose: [NSManagedObject] = []
    let currentdate = NSDate()
    var UHI = String()
    
    var g = ""
    var d = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        print(currentdate)
        
        currentGlucoseValue.text = g
        let dateComponents = d.components(separatedBy: " ")
        if (dateComponents.count > 1){
            updateDate.text = "\(dateComponents[0]) \(dateComponents[1])"
        }else{
            updateDate.text = "No Data"
        }
        
        fetchDoctorsInfo()
    }
    /**
     View Controller life cycle method, it is called when navigated back to this screen
     */
    override func viewWillAppear(_ animated: Bool) {
        fetchDoctorsInfo()
    }
    
    var high = 0
    var low = 0
    var goal = 0
    var note = ""
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
        let fetchRequestGlucose =
            NSFetchRequest<NSManagedObject>(entityName: "GlucoseInfo")
        do{
            let glucoseInfo = try managedContext.fetch(fetchRequestGlucose)
            for glucoseData in glucoseInfo{
                if (UHI == glucoseData.value(forKey: "patientID") as? String){
                    goal = glucoseData.value(forKey: "goal") as? Int ?? 0
                    if (goal > 0){
                        glucoseGoal.text = "\(goal) mg/dl"
                    }
                    let h = glucoseData.value(forKey: "alert_high") as? Int ?? 0
                    if (h > 0){
                        high = h
                        alertHighValue.text = "\(high) mg/dl"
                    }
                    let l = glucoseData.value(forKey: "alert_low") as? Int ?? 0
                    if (l > 0){
                        low = l
                        alertLowValue.text = "\(low) mg/dl"
                    }
                    note = glucoseData.value(forKey: "doctor_notes") as? String ?? ""
                    if (note != ""){
                         doctorNotes.text = note
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
        if let eneteredValue = Int(enterGlucoseValue.text!) {
            if (Int(eneteredValue) >= high || Int(eneteredValue) <= low){
                let doctorsEmail = UserDefaults.standard.object(forKey: "doctorsEmail") as! String
                let emergencyEmail = UserDefaults.standard.object(forKey: "EmergencyConatctEmail") as! String
                
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([doctorsEmail, emergencyEmail])
                    mail.setSubject("Alert !!!")
                    mail.setMessageBody("<h3>Please take care of your dear one, as Glucose values has been recorded abnormally !!! </h3>", isHTML: true)
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
    ///MARK:- Mail Composser delegate method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    /**
     Save button used for saving the vital information
     */
    @IBAction func saveButtonClicked(_ sender: Any) {
        if(enterGlucoseValue.text != ""){
            checkforAbnormalValues()
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "GlucoseInfo",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
            
            person.setValue(uhi, forKey: "patientID")
            person.setValue(Int16(enterGlucoseValue.text!), forKey: "glucose_value")
            person.setValue(NSDate(), forKey: "date")
            person.setValue("mg/dl", forKey: "unit")
            
            person.setValue(goal, forKey: "goal")
            person.setValue(high, forKey: "alert_high")
            person.setValue(low, forKey: "alert_low")
            person.setValue(note, forKey: "doctor_notes")
            
            do {
                try managedContext.save()
                glucose.append(person)
                
                let glusoceVal = enterGlucoseValue.text!
                currentGlucoseValue.text = glusoceVal
                let date = "\(currentdate)"
                let displayDate = date.components(separatedBy: " ")
                updateDate.text = displayDate[0]
                
                enterGlucoseValue.text = ""
                
                let alert = UIAlertController(title: "Saved", message: "Your glucose values have been saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
}
