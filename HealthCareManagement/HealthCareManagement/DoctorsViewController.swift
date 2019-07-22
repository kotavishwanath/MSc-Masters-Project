//
//  DoctorsViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 27/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class DoctorsViewController: UIViewController {
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var GMCNumber: UILabel!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var uhinumberTxt: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var name: UITextField!
    
    var doctorname: String = ""
    var gmcNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
//        doctorName.text = doctorname
//        GMCNumber.text = gmcNumber
        doctorName.text = UserDefaults.standard.object(forKey: "DoctorName") as! String
        GMCNumber.text = UserDefaults.standard.object(forKey: "GMCNumber") as! String
        
        uhinumberTxt.layer.borderColor = UIColor.black.cgColor
        uhinumberTxt.layer.borderWidth = 1
        uhinumberTxt.layer.cornerRadius = 5.0
        
        dob.layer.borderColor = UIColor.black.cgColor
        dob.layer.borderWidth = 1
        dob.layer.cornerRadius = 5.0
        
        name.layer.borderColor = UIColor.black.cgColor
        name.layer.borderWidth = 1
        name.layer.cornerRadius = 5.0
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
        let uhi = Int(uhinumberTxt.text!)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")
        do {
            let patientsinfo = try managedContext.fetch(fetchRequest)
            for data in patientsinfo {
                if (uhi == Int(data.value(forKey: "uhi") as! Int)){
                    let emergencyContact = "Emerg. contact: \(data.value(forKey: "emergency_contact_name") as! String)"
                    let patientName = "Name: \(data.value(forKey: "display_name") as! String)"
                    let appointmentDate = data.value(forKey: "appointmentDate") as! String
                    let appointmentTime = data.value(forKey: "appointment_Time") as! String
                    let appointment = "Next Session: \(appointmentDate) at \(appointmentTime)"
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let uhinumber = "UHI: \(uhi ?? 00)"
                    
                    let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
                    
                    UserDefaults.standard.set(uhinumber, forKey: "PatientUHINumber")
                    UserDefaults.standard.set(emergencyContact, forKey: "EmergencyContact")
                    UserDefaults.standard.set(patientName, forKey: "PatientName")
                    UserDefaults.standard.set(appointment, forKey: "Appointment")
                    UserDefaults.standard.synchronize()
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let alert = UIAlertController(title: "Patient not found", message: "Please check patients UHI number correctly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "PatientUHINumber")
        UserDefaults.standard.removeObject(forKey: "EmergencyContact")
        UserDefaults.standard.removeObject(forKey: "PatientName")
        UserDefaults.standard.removeObject(forKey: "Appointment")
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}
