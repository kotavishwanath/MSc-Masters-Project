//
//  BloodPressureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 12/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class BloodPressureVC: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        print(currentdate)
        
        fetchDoctorsInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDoctorsInfo()
    }
    
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
                    let goalSys = bpData.value(forKey: "goal_systolic") as! Int
                    let goalDia = bpData.value(forKey: "goal_diastolic") as! Int
                    goal.text = "\(goalSys)/\(goalDia)"
                    
                    let alertHighSys = bpData.value(forKey: "alert_high_systolic") as! Int
                    let alertHighDia = bpData.value(forKey: "alert_high_diastolic") as! Int
                    alertHigh.text = "\(alertHighSys)/\(alertHighDia) mmHg"
                    
                    let alertLowSys = bpData.value(forKey: "alert_low_systolic") as! Int
                    let alertLowDia = bpData.value(forKey: "alert_low_diastolic") as! Int
                    alertLow.text = "\(alertLowSys)/\(alertLowDia) mmHg"
                    
                    doctorNotes.text = bpData.value(forKey: "doctor_notes") as? String
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
    
    @IBAction func saveButton(_ sender: Any) {
        
        // for the first time
        if(systolicTxt.text != "" && diastolicTxt.text != ""){
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
