//
//  DashboardViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 21/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class DashboardViewController: UIViewController {
    var name: String = ""
    var uhinumber: String = ""
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var uhiLbl: UILabel!
     var data = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        usernameLbl.text = "Name: \(name)"
        uhiLbl.text = "UHI: \(uhinumber)"
    }

    @IBAction func healthStatusButton(_ sender: Any) {
        //HealthStatusVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HealthStatusVC") as! HealthStatusVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func emergencyButton(_ sender: Any) {
    }
    
    @IBAction func pillboxButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PillBoxViewController") as! PillBoxViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func monitorButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonitorDashboardVC") as! MonitorDashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func appointmentBookingButton(_ sender: Any) {
        let vc = CalenderVC()
        vc.uhino = uhinumber
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")

        do{
            let patientsinfo = try managedContext.fetch(fetchRequest)
            for data in patientsinfo {
                if (Int64(uhinumber) == (data.value(forKey: "uhi") as? Int64)){
                    let date = data.value(forKey: "appointmentDate") as? String
                    if (date == "" || date == nil){
                        //CalenderView.bookedSlotDate = [12, 7, 8]
                        
                        vc.slotsBooked = [1, 2, 3]
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        //Alert
                        let appointmentDate = data.value(forKey: "appointmentDate") as! String
                        let appointmentTime = data.value(forKey: "appointment_Time") as! String
                        let alert = UIAlertController(title: "Already Booked", message: "Your appointment date is on \(appointmentDate), \(appointmentTime)", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                        alert.addAction(UIAlertAction(title: "Would you like to cancle the appointment ?", style: .cancel, handler: { (UIAlertAction) in
                            self.cancelAppointment()
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        //self.present(CalenderVC(), animated: true, completion: nil)
    }
    
    func cancelAppointment(){
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
                 if (Int64(uhinumber) == (data.value(forKey: "uhi") as? Int64)){
                    data.setValue("", forKey: "appointmentDate")
                    try managedContext.save()
                    
                    let alert = UIAlertController(title: "Cancelled", message: "Your appointment has been cancled successfully", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func telemedicineButton(_ sender: Any) {
//        TeleMedicineVC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeleMedicineVC") as! TeleMedicineVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logut(_ sender: Any) {
        
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "UHI")
        //Remove medications
        UserDefaults.standard.removeObject(forKey: "MedicineNamesList")
        UserDefaults.standard.removeObject(forKey: "TimesADay") 
        UserDefaults.standard.removeObject(forKey: "HowManyDays")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
