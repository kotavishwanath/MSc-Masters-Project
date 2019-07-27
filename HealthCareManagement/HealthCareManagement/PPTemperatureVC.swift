//
//  PPTemperatureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PPTemperatureVC: UIViewController {
    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var alertMaxValue: UITextField!
    @IBOutlet weak var alertMinValue: UITextField!
    @IBOutlet weak var goalValue: UITextField!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var timesADay: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    @IBOutlet weak var submitbtn: UIButton!
    
    var tempValue = String()
    var UHINumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = tempValue
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        let number = patientUHI.text!.components(separatedBy: " ")
        UHINumber = number[1]
        beforeMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
        afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func beforeMealClicked(_ sender: Any) {
    }
    @IBAction func afterMealClicked(_ sender: Any) {
    }
    @IBAction func addMedicineButton(_ sender: Any) {
    }
    @IBAction func submitButtonClicked(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")
        
        let entity =
            NSEntityDescription.entity(forEntityName: "TemperatureVitalInfo",
                                       in: managedContext)!
        let tempData = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        do{
            let patientInfo = try managedContext.fetch(fetchRequest)
            for data in patientInfo{
                if (Int64(UHINumber) == data.value(forKey: "uhi") as? Int64){
                    
                    tempData.setValue(UHINumber, forKey: "patientID")
                    
                    let maxValue = Float(alertMaxValue.text!)
                    tempData.setValue(maxValue, forKey: "alert_high_temperature")
                    
                    let minValue = Float(alertMinValue.text!)
                    tempData.setValue(minValue, forKey: "alert_low_temperature")
                    
                    let goalVal = Float(goalValue.text!)
                    tempData.setValue(goalVal, forKey: "goal")
                    
                    let note = doctorNotes.text
                    tempData.setValue(note, forKey: "doctor_notoes")//°F
                    
                    try managedContext.save()
                    //Also need to update the prescribtion
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
