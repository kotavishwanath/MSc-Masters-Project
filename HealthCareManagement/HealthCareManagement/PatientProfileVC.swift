//
//  PatientProfileVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData
/**
 This screen is basically used by doctor and all the recent values will be updated according to the patient. It will also show the emeergency contanct name of patient.
 */
class PatientProfileVC: UIViewController {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var uhiNumber: UILabel!
    @IBOutlet weak var emergencyContactName: UILabel!
    @IBOutlet weak var nextSession: UILabel!
    
    @IBOutlet weak var bpView: UIView!
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var pulseOxiView: UIView!
    @IBOutlet weak var glucoseView: UIView!
    @IBOutlet weak var heartRateView: UIView!
    @IBOutlet weak var hemoglobinView: UIView!
    
    @IBOutlet weak var bpData: UILabel!
    @IBOutlet weak var bpUpdatedDate: UILabel!
    @IBOutlet weak var tempData: UILabel!
    @IBOutlet weak var tempUpdatedDate: UILabel!
    @IBOutlet weak var pulseOxiData: UILabel!
    @IBOutlet weak var pulseOxiUpdatedDate: UILabel!
    @IBOutlet weak var glucoseData: UILabel!
    @IBOutlet weak var glucoseUpdatedDate: UILabel!
    @IBOutlet weak var heartRateData: UILabel!
    @IBOutlet weak var heartRateUpdatedDate: UILabel!
    @IBOutlet weak var hemoData: UILabel!
    @IBOutlet weak var hemoUpdatedDate: UILabel!
    
    /**
     Vitals information
     */
    var bloodPressureValue = String()
    var temperatureValue = String()
    var pulseoxiValue = String()
    var glucoseValue = String()
    var heartRateValue = String()
    var hemoValue = String()
    ///UHI number of a patient
    var UHI = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientName.text = (UserDefaults.standard.object(forKey: "PatientName") as! String)
        uhiNumber.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        let x = (uhiNumber.text)!.components(separatedBy: " ")
        UHI = x[1]
        
        emergencyContactName.text = (UserDefaults.standard.object(forKey: "EmergencyContact") as! String)
        nextSession.text = (UserDefaults.standard.object(forKey: "Appointment") as! String)
        
        self.navigationController?.navigationBar.isHidden = true
        
        /**
         On all the vital information views, I have added the tap gesture.
         */
        let guster = UITapGestureRecognizer (target: self, action: #selector(PatientProfileVC.bpviewTapped(_:)))
        bpView.isUserInteractionEnabled = true
        bpView.addGestureRecognizer(guster)
        
        let tempGuster = UITapGestureRecognizer (target: self, action: #selector(PatientProfileVC.tempviewTapped(_:)))
        temperatureView.isUserInteractionEnabled = true
        temperatureView.addGestureRecognizer(tempGuster)
        
        let oxiGuster = UITapGestureRecognizer (target: self, action: #selector(PatientProfileVC.oxiviewTapped(_:)))
        pulseOxiView.isUserInteractionEnabled = true
        pulseOxiView.addGestureRecognizer(oxiGuster)
        
        let glucoseGuster = UITapGestureRecognizer (target: self, action: #selector(PatientProfileVC.glucoseTapped(_:)))
        glucoseView.isUserInteractionEnabled = true
        glucoseView.addGestureRecognizer(glucoseGuster)
        
        let heartRateGuster = UITapGestureRecognizer (target: self, action: #selector(PatientProfileVC.heartRateTapped(_:)))
        heartRateView.isUserInteractionEnabled = true
        heartRateView.addGestureRecognizer(heartRateGuster)
        
        let hemoglobinGuster = UITapGestureRecognizer (target: self, action: #selector(PatientProfileVC.hemoglobinTapped(_:)))
        hemoglobinView.isUserInteractionEnabled = true
        hemoglobinView.addGestureRecognizer(hemoglobinGuster)
        
        updateVitalValues()
    }
    /**
     ViewWillAppear method is called when the user is navigating back to this screen
     */
    override func viewWillAppear(_ animated: Bool) {
        updateVitalValues()
    }
    /**
     Fetching all the vital latest values and its updated date and time
     */
    func updateVitalValues(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequestBP =
            NSFetchRequest<NSManagedObject>(entityName: "BloodPressureVitalInfo")
        let fetchRequestTemp =
            NSFetchRequest<NSManagedObject>(entityName: "TemperatureVitalInfo")
        let fetchRequestPulseOxi =
            NSFetchRequest<NSManagedObject>(entityName: "PulseOxiInfo")
        let fetchRequestGlucose =
            NSFetchRequest<NSManagedObject>(entityName: "GlucoseInfo")
        let fetchRequestHeartRate =
            NSFetchRequest<NSManagedObject>(entityName: "HeartRateInfo")
        let fetchRequestHemo =
            NSFetchRequest<NSManagedObject>(entityName: "HemoglobinInfo")
        
        do{
            let BPInfo = try managedContext.fetch(fetchRequestBP)
            let tempInfo = try managedContext.fetch(fetchRequestTemp)
            let pluseOxiInfo = try managedContext.fetch(fetchRequestPulseOxi)
            let glucoseInfo = try managedContext.fetch(fetchRequestGlucose)
            let heartRateInfo = try managedContext.fetch(fetchRequestHeartRate)
            let hemoInfo = try managedContext.fetch(fetchRequestHemo)
            ///Fetching Blood Pressure information and also last updated date and time
            for bpData in BPInfo{
                if (UHI == bpData.value(forKey: "patientID") as? String){
                    let systolicValue = bpData.value(forKeyPath: "systolic") as! Int
                    let diastolicValue = bpData.value(forKeyPath: "diastolic") as! Int
                    if (bpData.value(forKey: "date") != nil){
                        let d = bpData.value(forKey: "date") as! NSDate
                        self.bpData.text = "\(systolicValue)/\(diastolicValue)"
                        bloodPressureValue = "Current Value: \(systolicValue)/\(diastolicValue) mmHG"
                        bpUpdatedDate.text = "\(d)"
                    }
                }
            }
            ///Fetching Temperature information and also last updated date and time
            for tempData in tempInfo{
                if (UHI == tempData.value(forKey: "patientID") as? String){
                    let temp = tempData.value(forKey: "temprature_info") as! Float
//                    self.tempData.text = String(format: "%.1f", temp)
//                    temperatureValue = "Current Value: \( String(format: "%.1f", temp)) °F"
                    if (tempData.value(forKey: "date") != nil){
                        let d = tempData.value(forKey: "date") as! NSDate
                        self.tempData.text = String(format: "%.1f", temp)
                        temperatureValue = "Current Value: \( String(format: "%.1f", temp)) °F"
                        tempUpdatedDate.text = "\(d)"
                    }
                    
                }
            }
            ///Fetching PulseOxi information and also last updated date and time
            for pulseData in pluseOxiInfo{
                if (UHI == pulseData.value(forKey: "patientID") as? String){
                    let pulse = pulseData.value(forKey: "pulseoxi_value") as! Float
//                    pulseOxiData.text = String(format: "%.1f", pulse)
//                    pulseoxiValue = "Current Value: \(String(format: "%.1f", pulse)) %"
                    if (pulseData.value(forKey: "date") != nil){
                        let d = pulseData.value(forKey: "date") as! NSDate
                        pulseOxiData.text = String(format: "%.1f", pulse)
                        pulseoxiValue = "Current Value: \(String(format: "%.1f", pulse)) %"
                        pulseOxiUpdatedDate.text = "\(d)"
                    }
                }
            }
            ///Fetching Glucose information and also last updated date and time
            for glucoseData in glucoseInfo{
                if (UHI == glucoseData.value(forKey: "patientID") as? String){
                    let glucose = glucoseData.value(forKey: "glucose_value") as! Int
//                    self.glucoseData.text = "\(glucose)"
//                    glucoseValue = "Current Value: \(glucose) mg/dl"
                    if (glucoseData.value(forKey: "date") != nil){
                        let d = glucoseData.value(forKey: "date") as! NSDate
                        self.glucoseData.text = "\(glucose)"
                        glucoseValue = "Current Value: \(glucose) mg/dl"
                        glucoseUpdatedDate.text = "\(d)"
                    }
                }
            }
            ///Fetching Heartrate information and also last updated date and time
            for heartData in heartRateInfo{
                if (UHI == heartData.value(forKey: "patientID") as? String){
                    let rate = heartData.value(forKey: "heartrate_value") as! Int
//                    heartRateData.text = "\(rate)"
//                    heartRateValue = "Current Value: \(rate) bpm"
                    if (heartData.value(forKey: "date") != nil){
                        let d = heartData.value(forKey: "date") as! NSDate
                        heartRateData.text = "\(rate)"
                        heartRateValue = "Current Value: \(rate) bpm"
                        heartRateUpdatedDate.text = "\(d)"
                    }
                }
            }
            ///Fetching Hemoglobin information and also last updated date and time
            for hemoData in hemoInfo{
                if (UHI == hemoData.value(forKey: "patientID") as? String){
                    let hemo = hemoData.value(forKey: "hemoglobin_value") as! Float
//                    self.hemoData.text = String(format: "%.1f", hemo)
//                    hemoValue = "Current Value: \(String(format: "%.1f", hemo)) %"
                    if (hemoData.value(forKey: "date") != nil){
                        let d = hemoData.value(forKey: "date") as! NSDate
                        self.hemoData.text = String(format: "%.1f", hemo)
                        hemoValue = "Current Value: \(String(format: "%.1f", hemo)) %"
                        hemoUpdatedDate.text = "\(d)"
                    }
                }
            }
            
        }///Catch if any error
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    /**
     Navigating to Patient profile Blood pressure screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func bpviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPBloodPressureVC") as! PPBloodPressureVC
        if (bloodPressureValue != ""){
            vc.bpValue = bloodPressureValue
        }else {
            vc.bpValue = "New Patient"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
    Navigating to Patient profile Temperature screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func tempviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPTemperatureVC") as! PPTemperatureVC
        if (temperatureValue != ""){
            vc.tempValue = temperatureValue
        }else {
            vc.tempValue = "New Patient"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
    Navigating to Patient profile PulseOxi screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func oxiviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPPulseOxiMeterVC") as! PPPulseOxiMeterVC
        if (pulseoxiValue != ""){
            vc.oxiValue = pulseoxiValue
        }else {
            vc.oxiValue = "New Patient"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
    Navigating to Patient profile Glucose screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func glucoseTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPGlucoseVC") as! PPGlucoseVC
        if (glucoseValue != ""){
            vc.glucose = glucoseValue
        }else {
            vc.glucose = "New Patient"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
    Navigating to Patient profile Heart rate screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func heartRateTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPHeartRateVC") as! PPHeartRateVC
        if (heartRateValue != ""){
            vc.heartRate = heartRateValue
        }else {
            vc.heartRate = "New Patient"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
    Navigating to Patient profile Hemoglobin screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func hemoglobinTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPHemoglobinVC") as! PPHemoglobinVC
        if (hemoValue != ""){
            vc.hemo = hemoValue
        }else {
            vc.hemo = "New Patient"
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     When the user clicked on back button app will be navigating to the Doctors view controller
     */
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DoctorsViewController") as! DoctorsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
