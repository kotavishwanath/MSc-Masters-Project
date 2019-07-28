//
//  PillBoxViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 28/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PillBoxViewController: UIViewController {
    @IBOutlet weak var pillsTblView: UITableView!
    
    var medicineName = [String]()
    var timeADay = [Int]()
    var afterMeal = [Bool]()
    var beforeMeal = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "MedicalPrescription")
        do {
            let medicationInfo = try managedContext.fetch(fetchRequest)
            for data in medicationInfo{
                if (data.value(forKey: "patientID") != nil){
                    if (uhi == data.value(forKey: "patientID") as! String){
                        let name = data.value(forKey: "medicine_name") as! String
                        let times = data.value(forKey: "times_a_day") as! Int
                        let afterM = data.value(forKey: "after_meal") as! Bool
                        let beforeM = data.value(forKey: "before_meal") as! Bool
                        
                        medicineName.append(name)
                        timeADay.append(times)
                        afterMeal.append(afterM)
                        beforeMeal.append(beforeM)
                        //Need to update in a table view
                    }
                }
                else{
                    continue
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }

    @IBAction func backButtonClicked(_ sender: Any) {
        let name = UserDefaults.standard.object(forKey: "username") as! String
        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = uhi
        navigationController?.pushViewController(vc, animated: true)
    }
}
