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

    var UHI = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //For Reteriving the Blood Pressure Information
        UHI = UserDefaults.standard.object(forKey: "UHI") as! String
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
                if (UHI == (data.value(forKey: "patientID") as? String)){
                    systolicAry.append(data.value(forKey: "systolic") as! Int)
                    diastolicAry.append(data.value(forKey: "diastolic") as! Int)
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        let name = UserDefaults.standard.object(forKey: "username") as! String
        //        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = UHI
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
