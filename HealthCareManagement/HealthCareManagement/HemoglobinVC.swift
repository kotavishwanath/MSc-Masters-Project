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

    @IBOutlet weak var currentHemoglobinValue: UILabel!
    @IBOutlet weak var doctorNotes: UILabel!
    @IBOutlet weak var updatedDate: UILabel!
    @IBOutlet weak var enterHemoglobinValue: UITextField!
    
    var hemoglobin: [NSManagedObject] = []
    let currentdate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        print(currentdate)
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonitorDashboardVC") as! MonitorDashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        // for the first time
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
