//
//  ViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 21/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

enum MyTheme {
    case light
    case dark
}

class CalenderVC: UIViewController, CalenderDelegate {
    
    var patients:[NSManagedObject] = []
    var selectedDate:String = ""
    var selectedTime:String = ""
    var slotsBooked:[Int] = []
    var uhino:String = ""
    let timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("selcted dates: \(slotsBooked)")
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Calender"
        self.navigationController?.navigationBar.isTranslucent = false
        self.view.backgroundColor = Style.bgColor
        
        view.addSubview(calenderView)
        calenderView.delegate = self
        calenderView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive=true
        calenderView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive=true
        calenderView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive=true
        calenderView.heightAnchor.constraint(equalToConstant: 365).isActive=true
        
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(rightBarBtnAction))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissVC))
        
        if (self.navigationItem.leftBarButtonItem!.isEnabled){
            print("Visible")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden  = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
        calenderView.myCollectionView.collectionViewLayout.invalidateLayout()
    }
    /*
    func openTimePicker()  {
        timePicker.datePickerMode = UIDatePicker.Mode.time
        timePicker.frame = CGRect(x: 0.0, y: (self.view.frame.height/2 + 60), width: self.view.frame.width, height: 150.0)
        timePicker.backgroundColor = UIColor.white
        self.view.addSubview(timePicker)
        timePicker.addTarget(self, action: #selector(CalenderVC.startTimeDiveChanged), for: UIControl.Event.valueChanged)
    }
    
    @objc func startTimeDiveChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let timeslot = formatter.string(from: sender.date)
        timePicker.removeFromSuperview() // if you want to remove time picker
        
        saveAppointmentDatetime()
    }
    
    func saveAppointmentDatetime(){
        print(selectedDate)
        if (selectedDate == ""){
            return
        }
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
                if (Int64(uhino) == (data.value(forKey: "uhi") as? Int64)){
                    data.setValue(selectedDate, forKey: "appointmentDate")
                    try managedContext.save()
                    let alert = UIAlertController(title: "Successful", message: "Your appointment has been booked on \(selectedDate)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                        vc.name = (data.value(forKey: "username") as? String)!
                        vc.uhinumber = "\(data.value(forKey: "uhi") as! Int)"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
     */
    
    @objc func rightBarBtnAction(sender: UIBarButtonItem) {
//        print(123)
        //Time
        
//        self.openTimePicker()
        
        //======================
        
        print(selectedDate)
        if (selectedDate == "" || selectedTime == ""){
            return
        }
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
                if (Int64(uhino) == (data.value(forKey: "uhi") as? Int64)){
                    data.setValue(selectedDate, forKey: "appointmentDate")
                    data.setValue(selectedTime, forKey: "appointment_Time")
                    try managedContext.save()
                    let alert = UIAlertController(title: "Successful", message: "Your appointment has been booked on \(selectedDate), \(selectedTime)", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                        vc.name = (data.value(forKey: "username") as? String)!
                        vc.uhinumber = "\(data.value(forKey: "uhi") as! Int)"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        /*
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "PatientsContactInfo",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(selectedDate, forKey: "appointmentDate")
        do {
            try managedContext.save()
            patients.append(person)
            
            let alert = UIAlertController(title: "Successful", message: "Your appointment has been booked on \(selectedDate)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (UIAlertAction) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                self.navigationController?.pushViewController(vc, animated: true)
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
         */
    }
    
    @objc func dismissVC(sender: UIBarButtonItem) {
        //        //username UHI
        let name = UserDefaults.standard.object(forKey: "username") as! String
        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = uhi
        navigationController?.pushViewController(vc, animated: true)
        
      // self.dismiss(animated: true, completion: nil)
    }

    lazy var  calenderView: CalenderView = {
        let calenderView = CalenderView(theme: MyTheme.light)
        calenderView.slots = slotsBooked
        calenderView.translatesAutoresizingMaskIntoConstraints=false
        return calenderView
    }()
    
    func didTapDate(date: String, time: String, available: Bool) {
        if available == true {
            print(date)
            selectedDate = date
            selectedTime = time
        } else {
            showAlert()
        }
    }
    
    fileprivate func showAlert(){
        let alert = UIAlertController(title: "Unavailable", message: "This slot is already booked.\nPlease choose another date.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

