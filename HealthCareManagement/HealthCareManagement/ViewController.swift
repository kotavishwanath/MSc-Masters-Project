//
//  ViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 10/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
// https://www.youtube.com/watch?v=tP4OGvIRUC4 for coredata
// https://stackoverflow.com/questions/29825604/how-to-save-array-to-coredata for transformable data type in coredata
// http://www.bloodpressureuk.org/BloodPressureandyou/Thebasics/Bloodpressurechart for blood pressure values
// https://medium.com/@ankurvekariya/core-data-crud-with-swift-4-2-for-beginners-40efe4e7d1cc for updating the records and deleting the records from the coredata


import UIKit
import CoreData
import HealthKit

let healthKitStore:HKHealthStore = HKHealthStore()


class ViewController: UIViewController {

    @IBOutlet weak var docotrRegisterBtn: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var passwod: UITextField!
    @IBOutlet weak var keepSignIn: UIButton!
    
    var appointmentDate = String()
    var steps = Double()
    var age = Int()
    var bloodgroup = String()

//    enum bloodType: Int {
//       case HKBloodTypeNotSet = 0
//       case HKBloodTypeAPositive
//       case HKBloodTypeANegative
//       case HKBloodTypeBPositive
//       case HKBloodTypeBNegative
//       case HKBloodTypeABPositive
//       case HKBloodTypeABNegative
//       case HKBloodTypeOPositive
//       case HKBloodTypeONegative
//    };

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       // keepSignIn.setImage(UIImage(named: "empty_check"), for: .normal)
        //navigationController?.setNavigationBarHidden(true, animated: true)
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
                self.steps = steps
            }
           let (years, btype) = self.readProfilesFromHealthKit()
            self.age = years ?? 0
            UserDefaults.standard.set(self.steps, forKey: "Steps")
            UserDefaults.standard.set(self.age, forKey:"Age")
            UserDefaults.standard.synchronize()
            
        }
    }
   /*
    func getBloodType(type: HKBloodTypeObject?) -> String{
        var bloodType = ""
        if (type != nil){
            switch(type!){
                case .HKBloodTypeAPositive:
                    bloodType = "A+"
                case .HKBloodTypeANegative:
                    bloodType = "A-"
               
                    break
            }
            
        }
        
        return bloodType
    }
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
        
        healthKitStore.execute(query)
    }

    override func viewWillAppear(_ animated: Bool) {
         navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction func signinbutton(_ sender: Any) {
        // For fetching the data from the
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
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
                    //https://www.gmc-uk.org/registration-and-licensing/the-medical-register/a-guide-to-the-medical-register/find-a-doctors-record
                    let dcotorName = "Name: \((data.value(forKey: "first_name") as? String)!) \((data.value(forKey: "last_name") as? String)!)"
                    let gmcNumber = "GMC Ref. No.: \(uname)"
                    vc.doctorname = dcotorName
                    vc.gmcNumber = "GMC Ref. No.: \(uname)"
                    
                    UserDefaults.standard.set(dcotorName, forKey: "DoctorName")
                    UserDefaults.standard.set(gmcNumber, forKey: "GMCNumber")
                    UserDefaults.standard.synchronize()
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    /*
        if (uname == "doctor" && pass == "doctor"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DoctorsViewController") as! DoctorsViewController
        //https://www.gmc-uk.org/registration-and-licensing/the-medical-register/a-guide-to-the-medical-register/find-a-doctors-record
            vc.doctorname = "Name: \(uname)"
            vc.gmcNumber = "GMC Ref. No.: 54323456"
            navigationController?.pushViewController(vc, animated: true)
            return
        }
 */
        //3
        do {
            let patientsinfo = try managedContext.fetch(fetchRequest)
            for data in patientsinfo {
                if (uname == (data.value(forKey: "username") as! String)) && (pass == (data.value(forKey: "password") as! String)){
                    print(data.value(forKey: "uhi") as! Int)
                    print(data)
                /*  let alert = UIAlertController(title: "Logged In Successfully", message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil) */
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                    
                    let patientname = (data.value(forKey: "display_name") as? String)!
                    let patientUHI = "\(data.value(forKey: "uhi") as! Int)"
                    
                    UserDefaults.standard.set(patientname, forKey: "username")
                    UserDefaults.standard.set(patientUHI, forKey: "UHI")
                    UserDefaults.standard.synchronize()
                    
                    vc.name = patientname
                    vc.uhinumber = patientUHI
                    navigationController?.pushViewController(vc, animated: true)
                    return
                }
                
                //                let imgData = data.value(forKey: "profile_picture") as? Data
                
                //                let image = UIImage(data: imgData? as Data)
                //                print(image as Any)
                
            }
            
            let alert = UIAlertController(title: "UnSuccessful", message: "Please check your credentials", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            
            // patientsinfo.value(forKeyPath: "uhi") as? Int
            print(patientsinfo)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    @IBAction func registerbutotn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "RegestrationViewController") as! RegestrationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func keepMeSignInButton(_ sender: Any) {

        if keepSignIn.isSelected{
//            keepSignIn.layer.borderWidth = 1.0
//            keepSignIn.layer.borderColor = UIColor.green.cgColor
            //keepSignIn.setImage(UIImage(named: "check"), for: .normal)
            keepSignIn.isSelected = false
        }else{
            keepSignIn.isSelected = true
//            keepSignIn.layer.borderWidth = 1.0
//            keepSignIn.layer.borderColor = UIColor.red.cgColor
        }
        
    }
    @IBAction func doctorRegistration(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DoctorRegistrationViewController") as! DoctorRegistrationViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
