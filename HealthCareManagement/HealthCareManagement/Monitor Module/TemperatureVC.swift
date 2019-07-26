//
//  TemperatureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 14/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class TemperatureVC: UIViewController {

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
        let fetchRequestTemp =
            NSFetchRequest<NSManagedObject>(entityName: "TemperatureVitalInfo")
        do{
            let tempInfo = try managedContext.fetch(fetchRequestTemp)
            for tempData in tempInfo{
                if (UHI == tempData.value(forKey: "patientID") as? String){
                    tempGoal.text = String(format: "%.1f °F", tempData.value(forKey: "goal") as! Float)
                    tempAlertHigh.text = String(format: "%.1f °F", tempData.value(forKey: "alert_high_temperature") as! Float)
                    tempAlertLow.text = String(format: "%.1f °F", tempData.value(forKey: "alert_low_temperature") as! Float)
                    
                    doctorNotesOfTemperature.text = tempData.value(forKey: "doctor_notoes") as? String
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
        if(enterTempValue.text != ""){
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
