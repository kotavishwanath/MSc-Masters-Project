//
//  PPHemoglobinVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PPHemoglobinVC: UIViewController {

    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var timesPerDay: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    @IBOutlet weak var submitbtn: UIButton!
    
    var hemo = String()
    var UHINumber = ""
    var medicine = ""
    var timesADay = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        let number = patientUHI.text!.components(separatedBy: " ")
        UHINumber = number[1]
        currentValue.text = hemo
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
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
        let hemoMedication = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        if (medicineName.text != "" && timesPerDay.text != "" && (beforeMealBtn.isSelected || afterMealBtn.isSelected)){
            hemoMedication.setValue(UHINumber, forKey: "patientID")
            hemoMedication.setValue(medicineName.text!, forKey: "medicine_name")
            hemoMedication.setValue(Int(timesPerDay.text!), forKey: "times_a_day")
            hemoMedication.setValue(beforeMealBtn.isSelected, forKey: "before_meal")
            hemoMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
            hemoMedication.setValue("This medicine is for Hemoglobin", forKey: "info")
            do{
                try managedContext.save()
                medicineName.text = ""
                timesPerDay.text = ""
                beforeMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
                afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
            }catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
            }
        }
    }
    @IBAction func beforeMealBtnClicked(_ sender: Any) {
        beforeMealBtn.isSelected = true
        afterMealBtn.isSelected = false
    }
    @IBAction func afterMealBtnClicked(_ sender: Any) {
        afterMealBtn.isSelected = true
        beforeMealBtn.isSelected = false
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
            NSEntityDescription.entity(forEntityName: "HemoglobinInfo",
                                       in: managedContext)!
        let hemoData = NSManagedObject(entity: entity,
                                          insertInto: managedContext)
        
        let hemoentity =
            NSEntityDescription.entity(forEntityName: "MedicalPrescription",
                                       in: managedContext)!
        let hemoMedication = NSManagedObject(entity: hemoentity,
                                             insertInto: managedContext)
        
        do{
            let patientInfo = try managedContext.fetch(fetchRequest)
            for data in patientInfo{
                if (Int64(UHINumber) == data.value(forKey: "uhi") as? Int64){
                    
                    hemoData.setValue(UHINumber, forKey: "patientID")
                    
                    let notes = doctorNotes.text
                    hemoData.setValue(notes, forKey: "doctor_notes")
                    
                    if (medicineName.text != "" && timesPerDay.text != "" && (beforeMealBtn.isSelected || afterMealBtn.isSelected)){
                        hemoMedication.setValue(UHINumber, forKey: "patientID")
                        hemoMedication.setValue(medicineName.text!, forKey: "medicine_name")
                        hemoMedication.setValue(Int(timesPerDay.text!), forKey: "times_a_day")
                        hemoMedication.setValue(beforeMealBtn.isSelected, forKey: "before_meal")
                        hemoMedication.setValue(afterMealBtn.isSelected, forKey: "after_meal")
                        hemoMedication.setValue("This medicine is for Hemoglobin", forKey: "info")
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
