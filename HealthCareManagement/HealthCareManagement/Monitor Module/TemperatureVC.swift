//
//  TemperatureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 14/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
/**
 This class is used for updating the Temperature information by the registered patient
 */
class TemperatureVC: UIViewController, MFMailComposeViewControllerDelegate {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var tempAlertHigh: UILabel!
    @IBOutlet weak var tempAlertLow: UILabel!
    @IBOutlet weak var currentTempValue: UILabel!
    @IBOutlet weak var doctorNotesOfTemperature: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    @IBOutlet weak var tempGoal: UILabel!
    @IBOutlet weak var enterTempValue: UITextField!
    
    var temperature: [NSManagedObject] = []
    let currentdate = NSDate()
    var UHI = String()
    
    var te = ""
    var d = ""
    
    var high = -1.0
    var low = -1.0
    var goal = -1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentTempValue.text = te
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
        let fetchRequestTemp =
            NSFetchRequest<NSManagedObject>(entityName: "TemperatureVitalInfo")
        do{
            let tempInfo = try managedContext.fetch(fetchRequestTemp)
            for tempData in tempInfo{
                if (UHI == tempData.value(forKey: "patientID") as? String){
                    goal = Double(tempData.value(forKey: "goal") as? Float ?? 0.0)
                    if (goal > 0){
                        tempGoal.text = String(format: "%.1f °F", goal)
                    }
                    let h = Double(tempData.value(forKey: "alert_high_temperature") as? Float ?? 0.0)
                    if (h > 0){
                        high = h
                        tempAlertHigh.text = String(format: "%.1f °F", high)
                    }
                    let l = Double(tempData.value(forKey: "alert_low_temperature") as? Float ?? 0.0)
                    if (l > 0){
                         low = l
                         tempAlertLow.text = String(format: "%.1f °F", low)
                    }
                    note = tempData.value(forKey: "doctor_notoes") as? String ?? ""
                    if (note != ""){
                        doctorNotesOfTemperature.text = note
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
        
        if let eneteredValue = Double(enterTempValue.text!) {
            
            if (high < 0 || low < 0){
                return
            }
            
            if (Double(eneteredValue) >= high || Double(eneteredValue) <= low){
                let doctorsEmail = UserDefaults.standard.object(forKey: "doctorsEmail") as! String
                let emergencyEmail = UserDefaults.standard.object(forKey: "EmergencyConatctEmail") as! String
                
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([doctorsEmail, emergencyEmail])
                    mail.setSubject("Alert !!!")
                    mail.setMessageBody("<h3>Please take care of your dear one, as Temperature values has been recorded abnormally !!! </h3>", isHTML: true)
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
        if(enterTempValue.text != ""){
            checkforAbnormalValues()
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "TemperatureVitalInfo",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
            
            person.setValue(uhi, forKey: "patientID")
            person.setValue(Float(enterTempValue.text!), forKey: "temprature_info")
            person.setValue(NSDate(), forKey: "date")
            person.setValue("°F", forKey: "unit")
            
            person.setValue(goal, forKey: "goal")
            person.setValue(high, forKey: "alert_high_temperature")
            person.setValue(low, forKey: "alert_low_temperature")
            person.setValue(note, forKey: "doctor_notoes")
            
            do {
                try managedContext.save()
                temperature.append(person)
                
                let temp = enterTempValue.text!
                currentTempValue.text = temp
                let date = "\(currentdate)"
                let displayDate = date.components(separatedBy: " ")
                updateDate.text = displayDate[0]
                
                enterTempValue.text = ""
                
                let alert = UIAlertController(title: "Saved", message: "Your Temperature values have been saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    

}
