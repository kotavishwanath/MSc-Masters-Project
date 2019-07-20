//
//  GlucoseVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 14/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class GlucoseVC: UIViewController {
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
        let fetchRequestGlucose =
            NSFetchRequest<NSManagedObject>(entityName: "GlucoseInfo")
        do{
            let glucoseInfo = try managedContext.fetch(fetchRequestGlucose)
            for glucoseData in glucoseInfo{
                if (UHI == glucoseData.value(forKey: "patientID") as? String){
                    glucoseGoal.text = "\(glucoseData.value(forKey: "goal") as! Int) mg/dl"
                    alertHighValue.text = "\(glucoseData.value(forKey: "alert_high") as! Int) mg/dl"
                    alertLowValue.text = "\(glucoseData.value(forKey: "alert_low") as! Int) mg/dl"
                    doctorNotes.text = glucoseData.value(forKey: "doctor_notes") as? String
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
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        // for the first time
        if(enterGlucoseValue.text != ""){
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
