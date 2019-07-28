//
//  PPBloodPressureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PPBloodPressureVC: UIViewController {

    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var systolicMaxValue: UITextField!
    @IBOutlet weak var diastolicMaxValue: UITextField!
    @IBOutlet weak var systolicMinValue: UITextField!
    @IBOutlet weak var diastolicMinValue: UITextField!
    @IBOutlet weak var goalSystolicValue: UITextField!
    @IBOutlet weak var goalDiastolicValue: UITextField!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var numberOftimes: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    @IBOutlet weak var submitbtn: UIButton!
    
    var bpValue = String()
    var UHINumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = bpValue
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        let number = patientUHI.text!.components(separatedBy: " ")
        UHINumber = number[1]
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
    }
    @IBAction func beforMealClicked(_ sender: Any) {
    }
    @IBAction func afterMealClicked(_ sender: Any) {
    }
    
    @IBAction func addMedicineButton(_ sender: Any) {
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
        navigationController?.pushViewController(vc, animated: true)
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
            NSEntityDescription.entity(forEntityName: "BloodPressureVitalInfo",
                                       in: managedContext)!
        let bpData = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        do{
            let patientInfo = try managedContext.fetch(fetchRequest)
            for data in patientInfo{
                if (Int64(UHINumber) == data.value(forKey: "uhi") as? Int64){
                    
                    bpData.setValue(UHINumber, forKey: "patientID")
                    
                    let sysMaxValue = Int(systolicMaxValue.text!)
                    bpData.setValue(sysMaxValue, forKey: "alert_high_systolic")
                    
                    let diaMaxValue = Int(diastolicMaxValue.text!)
                    bpData.setValue(diaMaxValue, forKey: "alert_high_diastolic")
                    
                    let sysMinValue = Int(systolicMinValue.text!)
                    bpData.setValue(sysMinValue, forKey: "alert_low_systolic")
                    
                    let diaMinValue = Int(diastolicMinValue.text!)
                    bpData.setValue(diaMinValue, forKey: "alert_low_diastolic")
                    
                    let goalSysValue = Int(goalSystolicValue.text!)
                    bpData.setValue(goalSysValue, forKey: "goal_systolic")
                    
                    let goalDiaValue = Int(goalDiastolicValue.text!)
                    bpData.setValue(goalDiaValue, forKey: "goal_diastolic")
                    
                    let note = doctorNotes.text
                    bpData.setValue(note, forKey: "doctor_notes")
                    
                    try managedContext.save()
                    //Also need to update the prescribtion
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
