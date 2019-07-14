//
//  BloodPressureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 12/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class BloodPressureVC: UIViewController {

    @IBOutlet weak var currentBPValue: UILabel!
    @IBOutlet weak var savedDate: UILabel!
    @IBOutlet weak var goal: UILabel!
    @IBOutlet weak var systolicTxt: UITextField!
    @IBOutlet weak var diastolicTxt: UITextField!
    
    var bloodpressure: [NSManagedObject] = []
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
    
    @IBAction func saveButton(_ sender: Any) {
        
        // for the first time
        if(systolicTxt.text != "" && diastolicTxt.text != ""){
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext
            let entity =
                NSEntityDescription.entity(forEntityName: "BloodPressureVitalInfo",
                                           in: managedContext)!
            let person = NSManagedObject(entity: entity,
                                         insertInto: managedContext)
            let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
            
            person.setValue(uhi, forKey: "patientID")
            person.setValue(Int16(systolicTxt.text!), forKey: "systolic")
            person.setValue(Int16(diastolicTxt.text!), forKey: "diastolic")
            person.setValue(NSDate(), forKey: "date")
            person.setValue("mmHg", forKey: "unit")
            
            do {
                try managedContext.save()
                bloodpressure.append(person)
                
                currentBPValue.text = "\(String(describing: systolicTxt.text))/\(String(describing: diastolicTxt.text))"
                let date = "\(currentdate)"
                let displayDate = date.components(separatedBy: " ")
                savedDate.text = displayDate[0]
                
                systolicTxt.text = ""
                diastolicTxt.text = ""
                
                let alert = UIAlertController(title: "Saved", message: "Your blood pressure values have been saved successfully", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
    }

}
