//
//  DisplayPatientsListVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 26/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class DisplayPatientsListVC: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var patientsListTblView: UITableView!
    
    var patientName = ""
    var patientUHI = ""
    var patientDOB = ""
    
    var listOfPatients:[PatientsList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        patientsListTblView.delegate = self
        patientsListTblView.dataSource = self
        
        print(patientUHI)
        print(patientDOB)
        print(patientName)
        listOfPatients = fetchPatientData(name: patientName, dateOfbirth: patientDOB, uhi: patientUHI)
        print(listOfPatients.count)
    }
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DoctorsViewController") as! DoctorsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchPatientData(name: String, dateOfbirth: String, uhi: String) -> [PatientsList]{
        var tempAry: [PatientsList] = []
        
        var patientIdentifier:Int = 0
        if (uhi != ""){
            patientIdentifier = Int(uhi) ?? 0
        }
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return []
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")
        do {
            let patientsinfo = try managedContext.fetch(fetchRequest)
            for data in patientsinfo {
                if (patientIdentifier == Int(data.value(forKey: "uhi") as! Int)) || (dateOfbirth == data.value(forKey: "dob") as! String) || (name == data.value(forKey: "last_name") as! String){ //first_name
                    let fullname = "\(data.value(forKey: "first_name") as! String) \(data.value(forKey: "last_name") as! String)"
                    let birthDate = "\(data.value(forKey: "dob") as! String)"
                    let identifier = "\((data.value(forKey: "uhi") as! Int))"
                    let imgData = data.value(forKey: "profile_picture") as! NSData
                    let img = UIImage(data: imgData as Data)

                    let ary = PatientsList(name: fullname, UHI: identifier, dob: birthDate, profileImage: img ?? UIImage(named: "Profile") as Any as! UIImage)
                    tempAry.append(ary)
                }
            }
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        if (tempAry.count == 0){
            let alert = UIAlertController(title: "Patient not found", message: "Please check patients details correctly", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        return tempAry
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfPatients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let patientInfo = listOfPatients[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell") as! PatientsListCell
        cell.setPatient(info: patientInfo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedPatient = listOfPatients[indexPath.row]
        navigateToDahboard(number: selectedPatient.UHI)

    }
    
   
    func navigateToDahboard(number: String){
        let uhi = Int(number)
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
                    var appointmentDate = ""
                    var appointmentTime = ""
                    
                    if ((data.value(forKey: "appointmentDate") != nil) || (data.value(forKey: "appointment_Time") != nil)){
                        appointmentDate = data.value(forKey: "appointmentDate") as! String
                        appointmentTime = data.value(forKey: "appointment_Time") as! String
                    
                    }
                   
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
    

    
}


class PatientsList {
    var name: String
    var UHI: String
    var dob: String
    var profileImage: UIImage
    
    init(name: String, UHI: String, dob: String, profileImage: UIImage) {
        self.name = name
        self.UHI = UHI
        self.dob = dob
        self.profileImage = profileImage
    }
    
}
