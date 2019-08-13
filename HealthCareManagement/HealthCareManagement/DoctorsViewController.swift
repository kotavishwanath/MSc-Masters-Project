//
//  DoctorsViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 27/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
/**
 This is where doctor serach for the patient, it can be done in three ways either by patient UHI number, date of bith and also by last name.
 */
class DoctorsViewController: UIViewController {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var GMCNumber: UILabel!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var uhinumberTxt: UITextField!
    @IBOutlet weak var dob: UITextField!
    @IBOutlet weak var name: UITextField!
    
    var doctorname: String = ""
    var gmcNumber: String = ""
    
    ///Storing patinet name
    var nameAry = NSMutableArray()
    ///Stroring UHI numbers
    var uhiAry = NSMutableArray()
    ///Storing patient Date of birth
    var dobAry = NSMutableArray()
    ///Storing patient profile picture
    var imgAry = NSMutableArray()
    
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
    /**
     Fetching the patients information using the name, date of  birth and UHI number
     - parameters:
         - name: Patient name
         - dateOfbirth: Patient Date of birth
         - uhi: Patient UHI number
     */
    func fetchDetails(name: String, dateOfbirth: String, uhi: String){
        let patientIdentifier = Int(uhi)
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
                if (patientIdentifier == Int(data.value(forKey: "uhi") as! Int)) || (dateOfbirth == data.value(forKey: "dob") as! String) || (name == data.value(forKey: "last_name") as! String){ //first_name
                    let fullname = "\(data.value(forKey: "first_name") as! String)) \(data.value(forKey: "last_name") as! String))"
                    let birthDate = "\(data.value(forKey: "dob") as! String)"
                    let identifier = "\((data.value(forKey: "uhi") as! Int))"
                    let imgData = data.value(forKey: "profile_picture") as! NSData
                    let img = UIImage(data: imgData as Data)
                    nameAry.add(fullname)
                    dobAry.add(birthDate)
                    uhiAry.add(identifier)
                    imgAry.add(img ?? UIImage(named: "Profile") as Any)
                    return
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        let alert = UIAlertController(title: "Patient not found", message: "Please check patients details correctly", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    /**
     Doctor enetered information about the patient is passed to the DisplayPatientsList screen as there may be multiple patinets with the same information.
     */
    @IBAction func submitButton(_ sender: Any) {
        
//        let uhinumber = uhinumberTxt.text
//        let dateOfbirth = dob.text
//        let names = name.text
    
//        fetchDetails(name: names!, dateOfbirth: dateOfbirth!, uhi: uhinumber!)
//        navigateToDahboard(number: Int(uhinumber!)!)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DisplayPatientsListVC") as! DisplayPatientsListVC
        vc.patientName = name.text!
        vc.patientDOB = dob.text!
        vc.patientUHI = uhinumberTxt.text!
        navigationController?.pushViewController(vc, animated: true)
        
        
    }
    /**
     Navigating to the Patient profile screen by using the patient uhiversal health identifer
     - Parameters:
        - number: Patinet UHI number
     */
    func navigateToDahboard(number: Int){
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
    /**
     Logout button which is used for loggout of the application and navigating to the Login screen.
     */
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
