//
//  PPPulseOxiMeterVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PPPulseOxiMeterVC: UIViewController {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var alertMinValue: UITextField!
    @IBOutlet weak var goal: UITextField!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var howmanyTimes: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var daysToTake: UITextField!
    
    var oxiValue = String()
    var UHINumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = oxiValue
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        let number = patientUHI.text!.components(separatedBy: " ")
        UHINumber = number[1]
        beforeMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
        afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
    }
    /**
     Before meal button is used for taking the medication
     */
    @IBAction func beforeMealBtnClicked(_ sender: Any) {
        beforeMealBtn.isSelected = true
        afterMealBtn.isSelected = false
    }
    /**
     After meal button is used for taking the medication
     */
    @IBAction func afterMealBtnClicked(_ sender: Any) {
        afterMealBtn.isSelected = true
        beforeMealBtn.isSelected = false
    }
    /**
     Add medication is for adding the medicines to the patient and also how many times to take per day
     */
    @IBAction func addMedication(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let pulseOxiEntity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let pulseOxiMedication = NSManagedObject(entity: pulseOxiEntity,
                                                insertInto: managedContext)
        if (medicineName.text != "" && howmanyTimes.text != "" && (beforeMealBtn.isSelected || afterMealBtn.isSelected)){
            pulseOxiMedication.setValue(UHINumber, forKey: "patientID")
            pulseOxiMedication.setValue(medicineName.text!, forKey: "medicine_name")
            pulseOxiMedication.setValue(Int(howmanyTimes.text!), forKey: "times_a_day")
            pulseOxiMedication.setValue(beforeMealBtn.isSelected, forKey: "before_meal")
            pulseOxiMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
            pulseOxiMedication.setValue("This medicine is for PulseOxi", forKey: "info")
            if (daysToTake.text == ""){
                pulseOxiMedication.setValue(1, forKey: "days_to_take")
            }else {
                pulseOxiMedication.setValue(Int(daysToTake.text!), forKey: "days_to_take")
            }
            do{
                try managedContext.save()
                medicineName.text = ""
                howmanyTimes.text = ""
                beforeMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
                afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
                daysToTake.text = ""
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    /**
     When the user clicked on back button app will be navigating to the Patient profile view controller
     */
    @IBAction func backButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Updating all the medicaitions required for the Pulseoxi data to the database
     */
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
            NSEntityDescription.entity(forEntityName: "PulseOxiInfo",
                                       in: managedContext)!
        let pulseOxiData = NSManagedObject(entity: entity,
                                       insertInto: managedContext)
        
        let pulseOxiEntity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let pulseOxiMedication = NSManagedObject(entity: pulseOxiEntity,
                                                 insertInto: managedContext)
        
        do{
            let patientInfo = try managedContext.fetch(fetchRequest)
            for data in patientInfo{
                if (Int64(UHINumber) == data.value(forKey: "uhi") as? Int64){
                    
                    pulseOxiData.setValue(UHINumber, forKey: "patientID")
                    
                    let minValue = Float(alertMinValue.text!)
                    pulseOxiData.setValue(minValue, forKey: "alert_low_pulse")
                    
                    let goalVal = Float(goal.text!)
                    pulseOxiData.setValue(goalVal, forKey: "goal")
                    
                    let note = doctorNotes.text
                    pulseOxiData.setValue(note, forKey: "doctor_notes")
                    if (medicineName.text != "" && howmanyTimes.text != "" && (beforeMealBtn.isSelected || afterMealBtn.isSelected)){
                        pulseOxiMedication.setValue(UHINumber, forKey: "patientID")
                        pulseOxiMedication.setValue(medicineName.text!, forKey: "medicine_name")
                        pulseOxiMedication.setValue(Int(howmanyTimes.text!), forKey: "times_a_day")
                        pulseOxiMedication.setValue(beforeMealBtn.isSelected, forKey: "before_meal")
                        pulseOxiMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
                        pulseOxiMedication.setValue("This medicine is for PulseOxi", forKey: "info")
                        if (daysToTake.text == ""){
                            pulseOxiMedication.setValue(1, forKey: "days_to_take")
                        }else {
                            pulseOxiMedication.setValue(Int(daysToTake.text!), forKey: "days_to_take")
                        }
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
