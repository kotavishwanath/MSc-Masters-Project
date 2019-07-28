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
        do{
            let patientInfo = try managedContext.fetch(fetchRequest)
            for data in patientInfo{
                if (Int64(UHINumber) == data.value(forKey: "uhi") as? Int64){
                    
                    hemoData.setValue(UHINumber, forKey: "patientID")
                    
                    let notes = doctorNotes.text
                    hemoData.setValue(notes, forKey: "doctor_notes")
                    
                    try managedContext.save()
                    //Also need to update the prescribtion
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
