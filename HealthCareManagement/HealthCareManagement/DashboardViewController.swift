//
//  DashboardViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 21/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
/**
 This screen is used for showing different options for the user to Book an appointment, Tele Medicine, Monitoring Health, Health status and Emergency calling functionality
 */
class DashboardViewController: UIViewController {
    /// Fetching the patients name from the users login
    var name: String = ""
    /// Fetching the patients Universal Identiifer Number from the users login
    var uhinumber: String = ""
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var uhiLbl: UILabel!
    var data = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        usernameLbl.text = "Name: \(name)"
        uhiLbl.text = "UHI: \(uhinumber)"
    }
    /**
     Navigating to the Health status screen.
     */
    @IBAction func healthStatusButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HealthStatusVC") as! HealthStatusVC
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to the Emergency services screen.
     */
    @IBAction func emergencyButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EmergencyVC") as! EmergencyVC
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to the Pillbox screen.
     */
    @IBAction func pillboxButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PillBoxViewController") as! PillBoxViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to the Monitor Health screen.
     */
    @IBAction func monitorButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MonitorDashboardVC") as! MonitorDashboardVC
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to the Appointment Booking screen.
     */
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
                        vc.slotsBooked = [1, 2, 3] // Setting some days as not avaliable just in an assumption of doctor is not avaliable on some particular days.
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        let appointmentDate = data.value(forKey: "appointmentDate") as! String
                        let appointmentTime = data.value(forKey: "appointment_Time") as! String
                         //Alert
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
    }
    /**
     Canceling the appointment which is already booked.
     */
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
    /**
     Navigating to the Telemedicine screen
     */
    @IBAction func telemedicineButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TeleMedicineVC") as! TeleMedicineVC
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Allowing the user to logout and navigating to the main screen of Sigin screen
     */
    @IBAction func logut(_ sender: Any) {
        ///Remove user details from the local storage
        UserDefaults.standard.removeObject(forKey: "username")
        UserDefaults.standard.removeObject(forKey: "UHI")
        ///Remove medications from the local storage
        UserDefaults.standard.removeObject(forKey: "MedicineNamesList")
        UserDefaults.standard.removeObject(forKey: "TimesADay") 
        UserDefaults.standard.removeObject(forKey: "HowManyDays")
        UserDefaults.standard.removeObject(forKey: "EmergencyConatctEmail")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
}
