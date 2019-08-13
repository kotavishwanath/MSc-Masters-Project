//
//  HemoglobinVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 15/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class HemoglobinVC: UIViewController {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var currentHemoglobinValue: UILabel!
    @IBOutlet weak var doctorNotes: UILabel!
    @IBOutlet weak var updatedDate: UILabel!
    @IBOutlet weak var enterHemoglobinValue: UITextField!
    @IBOutlet weak var idealValue: UILabel!
    
    var hemoglobin: [NSManagedObject] = []
    let currentdate = NSDate()
    var UHI = String()
    
    var hemo = ""
    var d = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        print(currentdate)
        
        currentHemoglobinValue.text = hemo
        let dateComponents = d.components(separatedBy: " ")
        if (dateComponents.count > 1){
            updatedDate.text = "\(dateComponents[0]) \(dateComponents[1])"
        }else{
            updatedDate.text = "No Data"
        }
        
        fetchDoctorsInfo()
    }
    /**
     View Controller life cycle method which will be used when navigating back to this screen
     */
    override func viewWillAppear(_ animated: Bool) {
        fetchDoctorsInfo()
    }
    var note = ""
    /**
     Fetching the doctor inputs like alerts and notes 
     */
    func fetchDoctorsInfo(){
        UHI = UserDefaults.standard.object(forKey: "UHI") as! String
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchPatient = NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")
        let fetchRequestHemo =
            NSFetchRequest<NSManagedObject>(entityName: "HemoglobinInfo")
        do{
            let hemoInfo = try managedContext.fetch(fetchRequestHemo)
            for hemoData in hemoInfo{
                if (UHI == hemoData.value(forKey: "patientID") as? String){
                    note = hemoData.value(forKey: "doctor_notes") as? String ?? ""
                    if (note != ""){
                        doctorNotes.text = note
                    }
                }
            }
            
            let patient = try managedContext.fetch(fetchPatient)
            for data in patient{
                if (Int(UHI) == data.value(forKey: "uhi") as? Int){
                   let gender = data.value(forKey: "mothers_madin_name") as! String
                    if gender == "M" || gender == "m"{
                        idealValue.text = "13.5 to 17.5 %"
                    }else{
                        idealValue.text = "12.0 to 15.5 %"
                    }
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    /**
     Back button which will navigate to Monitor Dahborad screen
     */
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonitorDashboardVC") as! MonitorDashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Save button used for saving the vital information
     */
    @IBAction func saveButtonClicked(_ sender: Any) {
        if(enterHemoglobinValue.text != ""){
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "HemoglobinInfo",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
            
            person.setValue(uhi, forKey: "patientID")
            person.setValue(Float(enterHemoglobinValue.text!), forKey: "hemoglobin_value")
            person.setValue(NSDate(), forKey: "date")
            person.setValue("%", forKey: "unit")
            
            person.setValue(note, forKey: "doctor_notes")
            
            do {
                try managedContext.save()
                hemoglobin.append(person)
                
                let hemoValue = enterHemoglobinValue.text!
                currentHemoglobinValue.text = hemoValue
                let date = "\(currentdate)"
                let displayDate = date.components(separatedBy: " ")
                updatedDate.text = displayDate[0]
                
                enterHemoglobinValue.text = ""
                
                let alert = UIAlertController(title: "Saved", message: "Your Hemoglobin values have been saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }
    
}
