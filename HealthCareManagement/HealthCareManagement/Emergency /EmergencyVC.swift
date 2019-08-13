//
//  EmergencyVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 07/08/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class EmergencyVC: UIViewController {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var qrImage: UIImageView!
    var contactnumber = 0
    override func viewDidLoad() {
        super.viewDidLoad()

       let Uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchPatient = NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")
        
        do{
            let patient = try managedContext.fetch(fetchPatient)
            for data in patient{
                if (Int(Uhi) == data.value(forKey: "uhi") as? Int){
                    contactnumber = data.value(forKey: "emergency_contact_number") as! Int
                    let imgData = data.value(forKey: "qrCode") as? NSData
                    if (imgData == nil){
                        qrImage.image = UIImage(named: "qr_brown_big")
                    } else {
                        qrImage.image = UIImage(data: imgData! as Data)
                    }
                    
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    /**
     Close button is used for dimissing the current view and navigating to the Dashboard view controller
     */
    @IBAction func closeBtn(_ sender: Any) {
        let name = UserDefaults.standard.object(forKey: "username") as! String
        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = uhi
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Sos button is used for calling to the emergency number
     */
    @IBAction func sosBtn(_ sender: Any) {
        guard let number = URL(string: "tel://" + "999") else { return }
        UIApplication.shared.open(number)
    }
    /**
     Need Help button will be calling emergency contact number
     */
    @IBAction func needHelpBtn(_ sender: Any) {
        //import data form core
        guard let number = URL(string: "tel://" + "\(contactnumber)") else { return }
        UIApplication.shared.open(number)
    }

}
