//
//  PPGlucoseVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PPGlucoseVC: UIViewController {

    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var alertMaxValue: UITextField!
    @IBOutlet weak var alertMinValue: UITextField!
    @IBOutlet weak var goal: UITextField!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var howManyTimes: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    @IBOutlet weak var submitbtn: UIButton!
    
    var glucose = String()
    var UHINumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = glucose
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        let number = patientUHI.text!.components(separatedBy: " ")
        UHINumber = number[1]
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
    }
    
    @IBAction func beforeMealBtnClicked(_ sender: Any) {
        beforeMealBtn.isSelected = true
        afterMealBtn.isSelected = false
    }
    @IBAction func afterMealBtnClicked(_ sender: Any) {
        afterMealBtn.isSelected = true
        beforeMealBtn.isSelected = false
    }
    @IBAction func addMedication(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let glucoseEntity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let glucoseMedication = NSManagedObject(entity: glucoseEntity,
                                             insertInto: managedContext)
        if (medicineName.text != "" && howManyTimes.text != "" && (beforeMealBtn.isSelected || afterMealBtn.isSelected)){
            glucoseMedication.setValue(UHINumber, forKey: "patientID")
            glucoseMedication.setValue(medicineName.text!, forKey: "medicine_name")
            glucoseMedication.setValue(Int(howManyTimes.text!), forKey: "times_a_day")
            glucoseMedication.setValue(beforeMealBtn.isSelected, forKey: "before_meal")
            glucoseMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
            glucoseMedication.setValue("This medicine is for Glucose", forKey: "info")
            do{
                try managedContext.save()
                medicineName.text = ""
                howManyTimes.text = ""
                beforeMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
                afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    @IBAction func backButtonClicked(_ sender: Any) {
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
            NSEntityDescription.entity(forEntityName: "GlucoseInfo",
                                       in: managedContext)!
        let glucoseData = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        let glucoseEntity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let glucoseMedication = NSManagedObject(entity: glucoseEntity,
                                                insertInto: managedContext)
        
        do{
            let patientInfo = try managedContext.fetch(fetchRequest)
            for data in patientInfo{
                if (Int64(UHINumber) == data.value(forKey: "uhi") as? Int64){
                    
                    glucoseData.setValue(UHINumber, forKey: "patientID")
                    
                    let maxValue = Int(alertMaxValue.text!)
                    glucoseData.setValue(maxValue, forKey: "alert_high")
                    
                    let minValue = Int(alertMinValue.text!)
                    glucoseData.setValue(minValue, forKey: "alert_low")
                    
                    let goalVal = Int(goal.text!)
                    glucoseData.setValue(goalVal, forKey: "goal")
                    
                    let notes = doctorNotes.text
                    glucoseData.setValue(notes, forKey: "doctor_notes")
                    
                    if (medicineName.text != "" && howManyTimes.text != "" && (beforeMealBtn.isSelected || afterMealBtn.isSelected)){
                        glucoseMedication.setValue(UHINumber, forKey: "patientID")
                        glucoseMedication.setValue(medicineName.text!, forKey: "medicine_name")
                        glucoseMedication.setValue(Int(howManyTimes.text!), forKey: "times_a_day")
                        glucoseMedication.setValue(beforeMealBtn.isSelected, forKey: "before_meal")
                        glucoseMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
                        glucoseMedication.setValue("This medicine is for Glucose", forKey: "info")
                    }else {
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
