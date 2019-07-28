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
        beforeMealbtn.isSelected = true
        afterMealBtn.isSelected = false
    }
    @IBAction func afterMealBtnClicked(_ sender: Any) {
        afterMealBtn.isSelected = true
        beforeMealbtn.isSelected = false
    }
    @IBAction func addMedication(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let heartMedication = NSManagedObject(entity: entity,
                                             insertInto: managedContext)
        if (medicinName.text != "" && timesPerDay.text != "" && (beforeMealbtn.isSelected || afterMealBtn.isSelected)){
            heartMedication.setValue(UHINumber, forKey: "patientID")
            heartMedication.setValue(medicinName.text!, forKey: "medicine_name")
            heartMedication.setValue(Int(timesPerDay.text!), forKey: "times_a_day")
            heartMedication.setValue(beforeMealbtn.isSelected, forKey: "before_meal")
            heartMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
            heartMedication.setValue("For Heart Rate", forKey: "info")
            do{
                try managedContext.save()
                medicinName.text = ""
                timesPerDay.text = ""
                beforeMealbtn.setImage(UIImage(named: "empty_check"), for: .normal)
                afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
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
        
        let heartentity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let heartMedication = NSManagedObject(entity: heartentity,
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
                    
                    if (medicinName.text != "" && timesPerDay.text != "" && (beforeMealbtn.isSelected || afterMealBtn.isSelected)){
                        heartMedication.setValue(UHINumber, forKey: "patientID")
                        heartMedication.setValue(medicinName.text!, forKey: "medicine_name")
                        heartMedication.setValue(Int(timesPerDay.text!), forKey: "times_a_day")
                        heartMedication.setValue(beforeMealbtn.isSelected, forKey: "before_meal")
                        heartMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
                        heartMedication.setValue("For Heart Rate", forKey: "info")
                    }else{
                        let alert = UIAlertController(title: "Medication Message", message: "Do you want to submit details without any medication?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: nil))
                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (UIAlertAction) in
                            do{
                                try managedContext.save()
                            }catch let error as NSError {
                                print("Could not fetch. \(error), \(error.userInfo)")
                            }
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
                            self.navigationController?.pushViewController(vc, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    try managedContext.save()
                    let alert = UIAlertController(title: "Saved", message: "Values updated successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
