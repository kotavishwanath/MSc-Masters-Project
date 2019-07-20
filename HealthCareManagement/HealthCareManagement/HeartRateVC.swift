//
//  HeartRateVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 15/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class HeartRateVC: UIViewController {

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
        let fetchRequestHeartRate =
            NSFetchRequest<NSManagedObject>(entityName: "HeartRateInfo")
        do{
            let heartRateInfo = try managedContext.fetch(fetchRequestHeartRate)
            for heartData in heartRateInfo{
                if (UHI == heartData.value(forKey: "patientID") as? String){
                    goal.text = "\(heartData.value(forKey: "goal") as! Int) bpm"
                    alertLow.text = "\(heartData.value(forKey: "alert_low") as! Int) bpm"
                    alertHigh.text = "\(heartData.value(forKey: "alert_high") as! Int) bpm"
                    doctorNotes.text = heartData.value(forKey: "doctor_notes") as? String
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
        if(currentHeartRateValue.text != ""){
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
