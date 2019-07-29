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
        beforeMealBtn.isSelected = true
        afterMealBtn.isSelected = false
    }
    @IBAction func afterMealClicked(_ sender: Any) {
        afterMealBtn.isSelected = true
        beforeMealBtn.isSelected = false
    }
    @IBAction func addMedicineButton(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let tempeartureEntity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let tempeartureMedication = NSManagedObject(entity: tempeartureEntity,
                                                insertInto: managedContext)
        if (medicineName.text != "" && timesADay.text != "" && (beforeMealBtn.isSelected || afterMealBtn.isSelected)){
            tempeartureMedication.setValue(UHINumber, forKey: "patientID")
            tempeartureMedication.setValue(medicineName.text!, forKey: "medicine_name")
            tempeartureMedication.setValue(Int(timesADay.text!), forKey: "times_a_day")
            tempeartureMedication.setValue(beforeMealBtn.isSelected, forKey: "before_meal")
            tempeartureMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
            tempeartureMedication.setValue("This medicine is for Temperature", forKey: "info")
            do{
                try managedContext.save()
                medicineName.text = ""
                timesADay.text = ""
                beforeMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
                afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
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
        let tempeartureEntity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let tempeartureMedication = NSManagedObject(entity: tempeartureEntity,
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
                    
                    if (medicineName.text != "" && timesADay.text != "" && (beforeMealBtn.isSelected || afterMealBtn.isSelected)){
                        tempeartureMedication.setValue(UHINumber, forKey: "patientID")
                        tempeartureMedication.setValue(medicineName.text!, forKey: "medicine_name")
                        tempeartureMedication.setValue(Int(timesADay.text!), forKey: "times_a_day")
                        tempeartureMedication.setValue(beforeMealBtn.isSelected, forKey: "before_meal")
                        tempeartureMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
                        tempeartureMedication.setValue("This medicine is for Temperature", forKey: "info")
                    } else {
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
                    //Also need to update the prescribtion
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
