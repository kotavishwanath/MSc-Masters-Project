//
//  BloodPressureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 12/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
import MessageUI
/**
 This class is used for updating the Blood Pressure information by the registered patient
 */
class BloodPressureVC: UIViewController, MFMailComposeViewControllerDelegate {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var currentBPValue: UILabel!
    @IBOutlet weak var savedDate: UILabel!
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var systolicTxt: UITextField!
    @IBOutlet weak var diastolicTxt: UITextField!
    @IBOutlet weak var alertHigh: UILabel!
    @IBOutlet weak var alertLow: UILabel!
    @IBOutlet weak var doctorNotes: UILabel!
    
    var bloodpressure: [NSManagedObject] = []
    let currentdate = NSDate()
    var UHI = String()
    var alertHighSys = -1
    var alertHighDia = -1
    var alertLowSys = -1
    var alertLowDia = -1
    
    var bp = ""
    var d = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        print(currentdate)
        
        currentBPValue.text = bp
        let dateComponents = d.components(separatedBy: " ")
        if (dateComponents.count > 1){
            savedDate.text = "\(dateComponents[0]) \(dateComponents[1])"
        }else{
            savedDate.text = "No Data"
        }
    
        fetchDoctorsInfo()
    }
    /**
     View Controller life cycle method, it is called when navigated back to this screen
     */
    override func viewWillAppear(_ animated: Bool) {
        fetchDoctorsInfo()
    }
    
    var goalSys = 0
    var goalDia = 0
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
        let fetchRequestBP =
            NSFetchRequest<NSManagedObject>(entityName: "BloodPressureVitalInfo")
        do{
            let BPInfo = try managedContext.fetch(fetchRequestBP)
            for bpData in BPInfo{
                if (UHI == bpData.value(forKey: "patientID") as? String){
                    
//                    guard let goalSys = bpData.value(forKey: "goal_systolic") as? Int else {
//                        return
//                    }
                    goalSys = bpData.value(forKey: "goal_systolic") as? Int ?? 0
                    goalDia = bpData.value(forKey: "goal_diastolic") as? Int ?? 0
                    
                    if (goalSys > 0 && goalDia > 0){
                        goal.text = "\(goalSys)/\(goalDia) mm Hg"
                    }
                    
                    let ahs = bpData.value(forKey: "alert_high_systolic") as? Int ?? 0
                    print("AHS: \(ahs)")
                    let ahd = bpData.value(forKey: "alert_high_diastolic") as? Int ?? 0
                    print("AHD: \(ahd)")
                    if (ahs > 0 && ahd > 0){
                        alertHighSys = ahs
                        alertHighDia = ahd
                        alertHigh.text = "\(alertHighSys)/\(alertHighDia) mm Hg"
                    }
                    
                    let als = bpData.value(forKey: "alert_low_systolic") as? Int ?? 0
                    print("ALS: \(als)")
                    let ald = bpData.value(forKey: "alert_low_diastolic") as? Int ?? 0
                    print("ALD: \(ald)")
                    if (als > 0 && ald > 0){
                        alertLowSys = als
                        alertLowDia = ald
                        alertLow.text = "\(alertLowSys)/\(alertLowDia) mm Hg"
                    }
                    
                    note = bpData.value(forKey: "doctor_notes") as? String ?? ""
                    if (note != ""){
                        doctorNotes.text = note
                        //bpData.value(forKey: "doctor_notes") as? String
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
        if let eneteredsysValue = Int(systolicTxt.text!), let entereddiaValue = Int(diastolicTxt.text!){
            if (alertHighSys < 0 || alertHighDia < 0 || alertLowSys < 0 || alertLowDia < 0){
                return
            }
            
            let alertHsys = alertHighSys
            let alertHDia = alertHighDia
            let alertLSys = alertLowSys
            let alertLDia = alertLowDia
            
            if (Int(eneteredsysValue) >= alertHsys || Int(eneteredsysValue) <= alertLSys || Int(entereddiaValue) >= alertHDia || Int(entereddiaValue) <= alertLDia){
                let doctorsEmail = UserDefaults.standard.object(forKey: "doctorsEmail") as! String
                let emergencyEmail = UserDefaults.standard.object(forKey: "EmergencyConatctEmail") as! String
                
                if MFMailComposeViewController.canSendMail() {
                    let mail = MFMailComposeViewController()
                    mail.mailComposeDelegate = self
                    mail.setToRecipients([doctorsEmail, emergencyEmail])
                    mail.setSubject("Alert !!!")
                    mail.setMessageBody("<h3>Please take care of your dear one, as Blood Pressure values has been recorded abnormally !!! </h3>", isHTML: true)
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
    @IBAction func saveButton(_ sender: Any) {
        if(systolicTxt.text != "" && diastolicTxt.text != ""){
            checkforAbnormalValues()
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "BloodPressureVitalInfo",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
            
            person.setValue(uhi, forKey: "patientID")
            person.setValue(Int16(systolicTxt.text!), forKey: "systolic")
            person.setValue(Int16(diastolicTxt.text!), forKey: "diastolic")
            person.setValue(NSDate(), forKey: "date")
            person.setValue("mmHg", forKey: "unit")
            
            person.setValue(alertHighSys, forKey: "alert_high_systolic")
            person.setValue(alertHighDia, forKey: "alert_high_diastolic")
            person.setValue(alertLowSys, forKey: "alert_low_systolic")
            person.setValue(alertLowDia, forKey: "alert_low_diastolic")
            person.setValue(goalSys, forKey: "goal_systolic")
            person.setValue(goalDia, forKey: "goal_diastolic")
            person.setValue(note, forKey: "doctor_notes")
            
            do {
                try managedContext.save()
                bloodpressure.append(person)
                
                let systolic = systolicTxt.text!
                let diastolic = diastolicTxt.text!
                
                currentBPValue.text = "\(systolic)/\(diastolic)"
                let date = "\(currentdate)"
                let displayDate = date.components(separatedBy: " ")
                savedDate.text = displayDate[0]
                
                systolicTxt.text = ""
                diastolicTxt.text = ""
                
                let alert = UIAlertController(title: "Saved", message: "Your blood pressure values have been saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }

}
