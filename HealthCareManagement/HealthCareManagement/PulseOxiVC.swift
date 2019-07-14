//
//  PulseOxiVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 14/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PulseOxiVC: UIViewController {

    @IBOutlet weak var currentOxiValue: UILabel!
    @IBOutlet weak var updatedDate: UILabel!
    @IBOutlet weak var oxiGoal: UILabel!
    @IBOutlet weak var enterOxiValue: UITextField!
    @IBOutlet weak var doctorsNotes: UILabel!
    
    var pulseOxi: [NSManagedObject] = []
    let currentdate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonitorDashboardVC") as! MonitorDashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        // for the first time
        if(enterOxiValue.text != ""){
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "PulseOxiInfo",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
            
            person.setValue(uhi, forKey: "patientID")
            person.setValue(Float(enterOxiValue.text!), forKey: "pulseoxi_value")
            person.setValue(NSDate(), forKey: "date")
            person.setValue("%", forKey: "unit")
            
            do {
                try managedContext.save()
                pulseOxi.append(person)
                
                currentOxiValue.text = "\(String(describing: enterOxiValue.text))"
                let date = "\(currentdate)"
                let displayDate = date.components(separatedBy: " ")
                updatedDate.text = displayDate[0]
                
                enterOxiValue.text = ""
                
                let alert = UIAlertController(title: "Saved", message: "Your pulse oximeter values have been saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        
    }
    
}
