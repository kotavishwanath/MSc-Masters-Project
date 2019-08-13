//
//  PillBoxViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 28/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
/**
 This class is used for showing all the medication list to the user and also how many times a day as well as wheather to take before meal or after meal
 */
class PillBoxViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var pillsTblView: UITableView!
    ///Medicsine name array
    var medicineName = [String]()
    ///How many times a day array
    var timeADay = [Int]()
    ///After meal array
    var afterMeal = [Bool]()
    ///Before meal array
    var beforeMeal = [Bool]()
    ///How many days to have array
    var daysToHave = [Int]()
    
    var medicineList: [MedicationList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pillsTblView.delegate = self
        pillsTblView.dataSource = self
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
                        let note = data.value(forKey: "info") as? String ?? " "
                        let daysToTake = data.value(forKey: "days_to_take") as! Int
                        
                        medicineName.append(name)
                        timeADay.append(times)
                        afterMeal.append(afterM)
                        beforeMeal.append(beforeM)
                        daysToHave.append(daysToTake)
                        
                        if (times == 1){
                            oneTimeScheduleNotification(messgae: name, before: beforeM, after: afterM, days: daysToTake)
                        }else if (times == 2){
                            twoTimesScheduleNotification(messgae: name, before: beforeM, after: afterM, days: daysToTake)
                        }else if (times == 3){
                            threeTimesScheduleNotification(messgae: name, before: beforeM, after: afterM, days: daysToTake)
                        }else {
                            //Considering 4 times
                            fourTimesScheduleNotification(messgae: name, before: beforeM, after: afterM, days: daysToTake)
                        }
                        medicineList.append(MedicationList(name: name, times: times, before: beforeM, after: afterM, notes: note, days: daysToTake ))
                    }
                }
                else{
                    continue
                }
            }
            UserDefaults.standard.set(medicineName, forKey: "MedicineNamesList")
            UserDefaults.standard.set(timeADay, forKey: "TimesADay")
            UserDefaults.standard.set(daysToHave, forKey: "HowManyDays")
//            let tele = TeleMedicineVC()
            
//            UserDefaults.standard.set(medicineList, forKey: "List")
            UserDefaults.standard.synchronize()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    //MARK:- Table view delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicineList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let medicineInfo = medicineList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedicationCell") as! MedicationCell
        cell.updateUI(info: medicineInfo)
        return cell
    }
    /**
     When the user clicked on back button app will be navigating to the Dashboard view controller
     */
    @IBAction func backButtonClicked(_ sender: Any) {
        let name = UserDefaults.standard.object(forKey: "username") as! String
        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = uhi
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Scheduling the notification with medicine name and time to take, it will notify the user for one time a day
     */
    func oneTimeScheduleNotification(messgae: String, before: Bool, after: Bool, days: Int){
        
        let content = UNMutableNotificationContent()
        let patinetname = UserDefaults.standard.object(forKey: "username") as! String
        content.title =  "Its time to take Medication"
        content.body = "Please take \(messgae) medicine"
        content.subtitle = (after) ? "Dear \(patinetname) please take medication after having Meal": "Dear \(patinetname) please take medication before Having Meal"
        content.sound = UNNotificationSound.default
        
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)

        let date = gregorian.date(from: components)!
        
        components.hour = 12
        components.minute = 0
        components.second = 0
        
        let triggerDaily = Calendar.current.dateComponents([.hour,.minute,.second,], from: date)
        let trigger: UNCalendarNotificationTrigger
        if (days > 1){
            trigger  = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
        }else {
            trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: false)
        }

        let request = UNNotificationRequest(identifier: "Medication Remainder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        })
    }
    /**
     Scheduling the notification with medicine name and time to take, it will notify the user for two times a day
     */
    func twoTimesScheduleNotification(messgae: String, before: Bool, after: Bool, days: Int){
        let content = UNMutableNotificationContent();
        let patinetname = UserDefaults.standard.object(forKey: "username") as! String
        content.title =  "Its time to take Medication"
        content.body = "Please take \(messgae) medicine"
        content.subtitle = (after) ? "Dear \(patinetname) please take medication after having Meal": "Dear \(patinetname) please take medication before Having Meal"
        content.sound = UNNotificationSound.default
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian);
        let now = Date();
        var components = gregorian.dateComponents(in: .autoupdatingCurrent, from: now)
        
        let hours = [9,19];
        
        for hour in hours {
            components.timeZone = TimeZone.current
            components.hour = hour;
            components.minute = 00;
            components.second = 00;
            
            let date = gregorian.date(from: components);
            let formatter = DateFormatter();
            formatter.dateFormat = "MM-dd-yyyy HH:mm";
            
            guard let dates = date else {
                return;
            }
            var fireDate: String?
            fireDate = formatter.string(from: dates);
            print("\(fireDate ?? "")"); // Just to Check
            
            let dailyTrigger = Calendar.current.dateComponents([.hour, .minute, .second], from: dates);
            let trigger: UNCalendarNotificationTrigger
            if (days > 1){
                trigger = UNCalendarNotificationTrigger.init(dateMatching: dailyTrigger, repeats: true);
            }else {
                trigger = UNCalendarNotificationTrigger.init(dateMatching: dailyTrigger, repeats: false);
            }
            
            let identifier = "Medication Remainder"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    /**
     Scheduling the notification with medicine name and time to take, it will notify the user for three times a day
     */
    func threeTimesScheduleNotification(messgae: String, before: Bool, after: Bool, days: Int){
        let content = UNMutableNotificationContent();
        let patinetname = UserDefaults.standard.object(forKey: "username") as! String
        content.title =  "Its time to take Medication"
        content.body = "Please take \(messgae) medicine"
        content.subtitle = (after) ? "Dear \(patinetname) please take medication after having Meal": "Dear \(patinetname) please take medication before Having Meal"
        content.sound = UNNotificationSound.default
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian);
        let now = Date();
        var components = gregorian.dateComponents(in: .autoupdatingCurrent, from: now)
        
        let hours = [9,13,19];
        
        for hour in hours {
            components.timeZone = TimeZone.current
            components.hour = hour;
            components.minute = 00;
            components.second = 00;
            
            let date = gregorian.date(from: components);
            let formatter = DateFormatter();
            formatter.dateFormat = "MM-dd-yyyy HH:mm";
            
            guard let dates = date else {
                return;
            }
            var fireDate: String?
            fireDate = formatter.string(from: dates);
            print("\(fireDate ?? "")"); // Just to Check
            
            let dailyTrigger = Calendar.current.dateComponents([.hour, .minute, .second], from: dates);
            let trigger: UNCalendarNotificationTrigger
            if (days > 1){
                trigger = UNCalendarNotificationTrigger.init(dateMatching: dailyTrigger, repeats: true);
            }else {
                trigger = UNCalendarNotificationTrigger.init(dateMatching: dailyTrigger, repeats: false);
            }
            
            let identifier = "Medication Remainder"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
    /**
     Scheduling the notification with medicine name and time to take, it will notify the user for four times a day
     */
    func fourTimesScheduleNotification(messgae: String, before: Bool, after: Bool, days: Int){
        let content = UNMutableNotificationContent();
        let patinetname = UserDefaults.standard.object(forKey: "username") as! String
        content.title =  "Its time to take Medication"
        content.body = "Please take \(messgae) medicine"
        content.subtitle = (after) ? "Dear \(patinetname) please take medication after having Meal": "Dear \(patinetname) please take medication before Having Meal"
        content.sound = UNNotificationSound.default
        
        let gregorian = Calendar(identifier: Calendar.Identifier.gregorian);
        let now = Date();
        var components = gregorian.dateComponents(in: .autoupdatingCurrent, from: now)
        
        let hours = [9,13,18,21];
        
        for hour in hours {
            components.timeZone = TimeZone.current
            components.hour = hour;
            components.minute = 00;
            components.second = 00;
            
            let date = gregorian.date(from: components);
            let formatter = DateFormatter();
            formatter.dateFormat = "MM-dd-yyyy HH:mm";
            
            guard let dates = date else {
                return;
            }
            var fireDate: String?
            fireDate = formatter.string(from: dates);
            print("\(fireDate ?? "")"); // Just to Check
            
            let dailyTrigger = Calendar.current.dateComponents([.hour, .minute, .second], from: dates);
            let trigger: UNCalendarNotificationTrigger
            if (days > 1){
                trigger = UNCalendarNotificationTrigger.init(dateMatching: dailyTrigger, repeats: true);
            }else {
                trigger = UNCalendarNotificationTrigger.init(dateMatching: dailyTrigger, repeats: false);
            }
            
            let identifier = "Medication Remainder"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Error \(error.localizedDescription)")
                }
            }
        }
    }
}
/**
 Creating the class for storing Medicine name, timesAday, Beformeal, Aftermeal, Notes and Days to take
 */
class MedicationList{
    var medicineName:String
    var timesADay:Int
    var beforeMeal:Bool
    var afterMeal:Bool
    var notes:String
    var dayToTake: Int
    init(name: String, times: Int, before: Bool, after: Bool, notes: String, days: Int) {
        self.medicineName = name
        self.timesADay = times
        self.beforeMeal = before
        self.afterMeal = after
        self.notes = notes
        self.dayToTake = days
    }
}
