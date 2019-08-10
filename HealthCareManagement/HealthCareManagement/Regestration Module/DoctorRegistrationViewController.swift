//
//  DoctorRegistrationViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 27/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class DoctorRegistrationViewController: UIViewController {
    var doctorsInfo:[NSManagedObject] = []
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var gmcNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var reenterPassword: UITextField!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var doctorEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func backBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "DoctorsInfo",
                                       in: managedContext)!
        let doctor = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        if (firstName.text != "" && lastName.text != "" && gmcNumber.text != "" && password.text != "" && reenterPassword.text != "" && doctorEmail.text != "") {
            if (password.text == reenterPassword.text){
                let emailCheck = isValidEmail(testStr: doctorEmail.text!)
                if (emailCheck == false){
                    let alert = UIAlertController(title: "Not Valid", message: "Please provide the valid email address", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                doctor.setValue(firstName.text, forKey: "first_name")
                doctor.setValue(lastName.text, forKey: "last_name")
                doctor.setValue(gmcNumber.text, forKey: "gmc_number")
                doctor.setValue(password.text, forKey: "password")
                doctor.setValue(doctorEmail.text, forKey: "email")
                
                UserDefaults.standard.setValue(doctorEmail.text, forKey: "doctorsEmail")
                UserDefaults.standard.synchronize()
                
                do {
                    try managedContext.save()
                    doctorsInfo.append(doctor)
                    let alert = UIAlertController(title: "Successful", message: "You have successfully registred ", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } catch let error as NSError {
                    print("Could not save. \(error), \(error.userInfo)")
                }
                
            }else{
                let alert = UIAlertController(title: "Not Valid", message: "Password not matching", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }else {
            let alert = UIAlertController(title: "Not Valid", message: "Please enter all the required fileds", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
