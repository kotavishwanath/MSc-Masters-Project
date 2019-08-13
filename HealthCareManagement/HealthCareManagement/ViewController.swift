//
//  ViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 10/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

/**
 Imported Coredata and HelathKit from the Apple
 */
import UIKit
import CoreData
import HealthKit

/// Creating the healthkit object
let healthKitStore:HKHealthStore = HKHealthStore()

class ViewController: UIViewController {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var docotrRegisterBtn: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var passwod: UITextField!
    @IBOutlet weak var keepSignIn: UIButton!
    
    /// Steps information of the user from the health app
    var steps = Double()
    /// Age infromation of the user from the health app
    var age = Int()
    /// Blood group infromation of the user from the health app
    var bloodgroup = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.blue.cgColor
        signInButton.layer.cornerRadius = 4.0
        
        registerButton.layer.borderWidth = 1
        registerButton.layer.borderColor = UIColor.blue.cgColor
        registerButton.layer.cornerRadius = 4.0
        
        docotrRegisterBtn.layer.borderWidth = 1
        docotrRegisterBtn.layer.borderColor = UIColor.blue.cgColor
        docotrRegisterBtn.layer.cornerRadius = 4.0
        
        username.layer.borderColor = UIColor.black.cgColor
        username.layer.borderWidth = 1
        username.layer.cornerRadius = 5.0
        
        passwod.layer.borderColor = UIColor.black.cgColor
        passwod.layer.borderWidth = 1
        passwod.layer.cornerRadius = 5.0
        
        integrateHealthKit()
    }
    /**
     Integrating the Health Kit and also asking for the users permession to share the deatils with the application
     */
    func integrateHealthKit() {
        let healthKitTypesToRead: Set<HKObjectType> = [
            HKObjectType.characteristicType(forIdentifier: .bloodType)!,
            HKObjectType.characteristicType(forIdentifier: .dateOfBirth)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!
        ]
        
        let healthKitTypesToWrite: Set<HKSampleType> = []
        
        if !HKHealthStore.isHealthDataAvailable(){
            print("Error Occured")
            return
        }
        healthKitStore.requestAuthorization(toShare: healthKitTypesToWrite , read: healthKitTypesToRead) { (success, error) in
            print("Read write authorization succeded")
            self.getTodaysSteps { (steps) in
                print("Steps: \(steps)")
                self.steps = steps
                UserDefaults.standard.set("\(steps)", forKey: "StepsCount")
            }
            ///  let (years, btype) it is a tuple in swift
            let (years, btype) = self.readProfilesFromHealthKit()
            self.age = years ?? 0
           
            UserDefaults.standard.set(self.age, forKey:"Age")
            UserDefaults.standard.synchronize()
        }
    }
    /**
     Reading the data from the Health app of the users device
     - parameters:
         - age: For getting the age information
         - bloodType: For getting the blood type information if avaiable in the users Health App
         - Returns: age and blood group of the patient
     */
    func readProfilesFromHealthKit() -> (age: Int?, bloodType: HKBloodTypeObject?){
        var age: Int?
        var bloodType: HKBloodTypeObject?
        
        do{
            let birthDay = try healthKitStore.dateOfBirthComponents()
            let calender = Calendar.current
            let currentYear = calender.component(.year, from: Date())
            age = currentYear - birthDay.year!
        }catch{
            print("Couldnt fetch data")
        }
        
        do {
            bloodType = try healthKitStore.bloodType()
        } catch {
            print("Couldnt fetch data")
        }
        
        return(age, bloodType)
    }
    
    
    /**
     Get the number of steps the user has been walked
     - Parameter completionHandler: The callback called after retrieval of the steps information from the HealthKit.
     */
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        /// Excute the query for fetching the information
        healthKitStore.execute(query)
    }
    /**
     ViewWillAppear method is called when the user is navigating back to this screen
     */
    override func viewWillAppear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(true, animated: true)
    }
    /**
     When clicked on signin button, this method checks the credentials of the user and navigative accordingly to the doctors screen or the patients screen
     */
    @IBAction func signinbutton(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PatientsContactInfo")
        
        let uname = username.text!
        let pass = passwod.text!
        
        if (uname == "" || pass == ""){
            let alert = UIAlertController(title: "Error", message: "Username or Password shouldnt be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let fetchRequestDoctor =
            NSFetchRequest<NSManagedObject>(entityName: "DoctorsInfo")
        do{
            let doctorsinfo = try managedContext.fetch(fetchRequestDoctor)
            for data in doctorsinfo{
                if (uname == (data.value(forKey: "gmc_number") as? String)) && (pass == (data.value(forKey: "password") as? String)){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DoctorsViewController") as! DoctorsViewController
                    
                    let dcotorName = "Name: \((data.value(forKey: "first_name") as? String)!) \((data.value(forKey: "last_name") as? String)!)"
                    let gmcNumber = "GMC Ref. No.: \(uname)"
                    vc.doctorname = dcotorName
                    vc.gmcNumber = "GMC Ref. No.: \(uname)"
                    /// Storing the Doctor name and General medication number for displaying the in the docotrs dashboard screen
                    UserDefaults.standard.set(dcotorName, forKey: "DoctorName")
                    UserDefaults.standard.set(gmcNumber, forKey: "GMCNumber")
                    UserDefaults.standard.synchronize()
                    /// Navigating to Doctors View controller
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        do {
            let patientsinfo = try managedContext.fetch(fetchRequest)
            for data in patientsinfo {
                if (uname == (data.value(forKey: "username") as! String)) && (pass == (data.value(forKey: "password") as! String)){
                    print(data.value(forKey: "uhi") as! Int)
                    print(data)
               
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                    
                    let patientname = (data.value(forKey: "display_name") as? String)!
                    let patientUHI = "\(data.value(forKey: "uhi") as! Int)"
                    let emergencyContactEmail = "\(data.value(forKey: "emergency_contact_email") as! String)"
                    /// Storing the username and Universal identifier number for fetching the data with respect to the particular patient
                    UserDefaults.standard.set(patientname, forKey: "username")
                    UserDefaults.standard.set(patientUHI, forKey: "UHI")
                    UserDefaults.standard.set(emergencyContactEmail, forKey: "EmergencyConatctEmail")
                    UserDefaults.standard.synchronize()
                    
                    vc.name = patientname
                    vc.uhinumber = patientUHI
                    /// Navigating to the patients dashboard view controller
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
            ///Alert when the user enters invalid credentials
            let alert = UIAlertController(title: "UnSuccessful", message: "Please check your credentials", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
//            print(patientsinfo)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    /**
      Navigating to the patient regestration screen
     */
    @IBAction func registerbutotn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegestrationViewController") as! RegestrationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Keep me signed is the functionality used for allowing the user to use the app without entering the login credentials again and again.
     */
    @IBAction func keepMeSignInButton(_ sender: Any) {
        if keepSignIn.isSelected{
            keepSignIn.isSelected = false
        }else{
            keepSignIn.isSelected = true
        }
    }
    /**
     Navigating to the doctors regestration screen
     */
    @IBAction func doctorRegistration(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DoctorRegistrationViewController") as! DoctorRegistrationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
