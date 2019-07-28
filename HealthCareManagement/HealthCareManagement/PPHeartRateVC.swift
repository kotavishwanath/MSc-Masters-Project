//
//  PPHeartRateVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PPHeartRateVC: UIViewController {

    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var alertMaxValue: UITextField!
    @IBOutlet weak var alertMinValue: UITextField!
    @IBOutlet weak var goal: UITextField!
    @IBOutlet weak var timesPerDay: UITextField!
    @IBOutlet weak var medicinName: UITextField!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var beforeMealbtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    @IBOutlet weak var submitbtn: UIButton!
    
    var heartRate = String()
    var UHINumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        let number = patientUHI.text!.components(separatedBy: " ")
        UHINumber = number[1]
        currentValue.text = heartRate
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
    }
    @IBAction func beforeMealBtnClicked(_ sender: Any) {
    }
    @IBAction func afterMealBtnClicked(_ sender: Any) {
    }
    @IBAction func addMedication(_ sender: Any) {
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func submitBtnClicked(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")
        
        let entity =
            NSEntityDescription.entity(forEntityName: "HeartRateInfo",
                                       in: managedContext)!
        let heartRateData = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
        do{
            let patientInfo = try managedContext.fetch(fetchRequest)
            for data in patientInfo{
                if (Int64(UHINumber) == data.value(forKey: "uhi") as? Int64){
                    
                    heartRateData.setValue(UHINumber, forKey: "patientID")
                    
                    let maxValue = Int(alertMaxValue.text!)
                    heartRateData.setValue(maxValue, forKey: "alert_high")
                    
                    let minValue = Int(alertMinValue.text!)
                    heartRateData.setValue(minValue, forKey: "alert_low")
                    
                    let goalVal = Int(goal.text!)
                    heartRateData.setValue(goalVal, forKey: "goal")
                    
                    let notes = doctorNotes.text
                    heartRateData.setValue(notes, forKey: "doctor_notes")
                    
                    try managedContext.save()
                    //Also need to update the prescribtion
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
