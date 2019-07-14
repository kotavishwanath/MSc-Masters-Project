//
//  HealthStatusVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 14/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class HealthStatusVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        //For Reteriving the Blood Pressure Information
        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        var systolicAry = [Int]()
        var diastolicAry = [Int]()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BloodPressureVitalInfo")
        do{
            let info = try managedContext.fetch(fetchRequest)
            for data in info{
                if (uhi == (data.value(forKey: "patientID") as? String)){
                    systolicAry.append(data.value(forKey: "systolic") as! Int)
                    diastolicAry.append(data.value(forKey: "diastolic") as! Int)
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
