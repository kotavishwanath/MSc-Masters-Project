//
//  MonitorDashboardVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 12/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreData
/**
 This class is used for showing all the vital latest values and also allows the user to connect to any BLE (Bluetooth Low Energy Devices)
 */
class MonitorDashboardVC: UIViewController,CBCentralManagerDelegate {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var webvw: UIWebView!
    
    @IBOutlet weak var bluetoothBtn: UIButton!
    @IBOutlet weak var bpView: UIView!
    @IBOutlet weak var temperatureView: UIView!
    @IBOutlet weak var pluseOxiView: UIView!
    @IBOutlet weak var glucoseView: UIView!
    @IBOutlet weak var heartRateView: UIView!
    @IBOutlet weak var hemoglobinView: UIView!
    
    @IBOutlet weak var bpValue: UILabel!
    @IBOutlet weak var tempValue: UILabel!
    @IBOutlet weak var pluseOxiValue: UILabel!
    @IBOutlet weak var glucoseValue: UILabel!
    @IBOutlet weak var heartRateValue: UILabel!
    @IBOutlet weak var hemoglobinValue: UILabel!
    @IBOutlet weak var bpUpdatedDate: UILabel!
    @IBOutlet weak var tempUpdatedDate: UILabel!
    @IBOutlet weak var pulseOxiUpdatedDate: UILabel!
    @IBOutlet weak var glucoseUpdatedDate: UILabel!
    @IBOutlet weak var heartRateUpdatedDate: UILabel!
    @IBOutlet weak var hemoUpdatedDate: UILabel!
    
    var manager:CBCentralManager!
    var UHI = String()
    
    var bloodPressureValue = String()
    var bloodPressureDate = String()
    var temperatureValue = String()
    var temperatureDate = String()
    var pulseoxiValue = String()
    var pulseoxiDate = String()
    var glucoseDate = String()
    var glucValue = String()
    var heartValue = String()
    var heartDate = String()
    var hemoglValue = String()
    var hemobloginDate = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        // Blood Pressure
        let guster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.bpviewTapped(_:)))
        
        bpView.isUserInteractionEnabled = true
        bpView.addGestureRecognizer(guster)
        
        // TemperatureVC
        let tempGuster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.tempviewTapped(_:)))
        
        temperatureView.isUserInteractionEnabled = true
        temperatureView.addGestureRecognizer(tempGuster)
        
        // PulseOxiVC
        let oxiGuster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.oxiviewTapped(_:)))
        
        pluseOxiView.isUserInteractionEnabled = true
        pluseOxiView.addGestureRecognizer(oxiGuster)
        
        // GlucoseVC
        let glucoseGuster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.glucoseTapped(_:)))
        
        glucoseView.isUserInteractionEnabled = true
        glucoseView.addGestureRecognizer(glucoseGuster)
        
        // Heart rate VC
        let heartRateGuster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.heartRateTapped(_:)))
        
        heartRateView.isUserInteractionEnabled = true
        heartRateView.addGestureRecognizer(heartRateGuster)
        
        // Hemoglobin VC
        let hemoglobinGuster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.hemoglobinTapped(_:)))
        
        hemoglobinView.isUserInteractionEnabled = true
        hemoglobinView.addGestureRecognizer(hemoglobinGuster)
        
        UHI = UserDefaults.standard.object(forKey: "UHI") as! String
        updateUI()
        
        let steps = UserDefaults.standard.object(forKey: "StepsCount") as! String
        print("Dashboard:  \(steps)")
        let age = UserDefaults.standard.object(forKey: "Age") as! Int
        //Steps Age
        let str = "Your age is \(String(describing: age)) & Todays steps count is \(steps)"
        //\(String(describing: steps))"
        let marquee = "<html><body><marquee>\(str)</marquee></body></html>"
        webvw.loadHTMLString(marquee, baseURL: nil)
    }
    /**
     Fetching all the information for the database and showing it.
     */
    func updateUI(){
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
            /// Fetching blood pressure infromation
            for bpData in BPInfo{
                if (UHI == bpData.value(forKey: "patientID") as? String){
                   let systolicValue = bpData.value(forKeyPath: "systolic") as! Int
                   let diastolicValue = bpData.value(forKeyPath: "diastolic") as! Int
//                   bpValue.text = "\(systolicValue)/\(diastolicValue)"
                    if ( bpData.value(forKey: "date") != nil){
                        let d = bpData.value(forKey: "date") as! NSDate
                        bpValue.text = "\(systolicValue)/\(diastolicValue)"
                        bpUpdatedDate.text = "\(d)"
                        bloodPressureValue = "\(systolicValue)/\(diastolicValue)"
                        bloodPressureDate = "\(d)"
                    }
                }
            }
            /// Fetching Temperature infromation
            for tempData in tempInfo{
               /* let i:Int = 0
                tempData.setValue(i, forKey: "temprature_info")*/
                if (UHI == tempData.value(forKey: "patientID") as? String){
                    let temp = tempData.value(forKey: "temprature_info") as! Float
//                    tempValue.text = String(format: "%.1f", temp)
                    if (tempData.value(forKey: "date") != nil){
                        let d = tempData.value(forKey: "date") as! NSDate
                        tempValue.text = String(format: "%.1f", temp)
                        tempUpdatedDate.text = "\(d)"
                        temperatureValue = "\(String(format: "%.1f", temp))"
                        temperatureDate = "\(d)"
                    }
                }
            }
            /// Fetching Pulse Oxi information infromation
            for pulseData in pluseOxiInfo{
                if (UHI == pulseData.value(forKey: "patientID") as? String){
                    let pulse = pulseData.value(forKey: "pulseoxi_value") as! Float
//                    pluseOxiValue.text = String(format: "%.1f", pulse)
                    if (pulseData.value(forKey: "date") != nil){
                        let d = pulseData.value(forKey: "date") as! NSDate
                        pluseOxiValue.text = String(format: "%.1f", pulse)
                        pulseOxiUpdatedDate.text = "\(d)"
                        pulseoxiValue = "\(String(format: "%.1f", pulse))"
                        pulseoxiDate = "\(d)"
                    }
                }
            }
            /// Fetching Glucose infromation
            for glucoseData in glucoseInfo{
                if (UHI == glucoseData.value(forKey: "patientID") as? String){
                    let glucose = glucoseData.value(forKey: "glucose_value") as! Int
//                    glucoseValue.text = "\(glucose)"
                    if (glucoseData.value(forKey: "date") != nil){
                        let d = glucoseData.value(forKey: "date") as! NSDate
                        glucoseValue.text = "\(glucose)"
                        glucoseUpdatedDate.text = "\(d)"
                        glucValue = "\(glucose)"
                        glucoseDate = "\(d)"
                    }
                }
            }
            /// Fetching Heartrate infromation
            for heartData in heartRateInfo{
                if (UHI == heartData.value(forKey: "patientID") as? String){
                    let rate = heartData.value(forKey: "heartrate_value") as! Int
//                    heartRateValue.text = "\(rate)"
                    if (heartData.value(forKey: "date") != nil){
                        let d = heartData.value(forKey: "date") as! NSDate
                        heartRateValue.text = "\(rate)"
                        heartRateUpdatedDate.text = "\(d)"
                        heartValue = "\(rate)"
                        heartDate = "\(d)"
                    }
                }
            }
            /// Fetching Hemoglobin infromation
            for hemoData in hemoInfo{
                if (UHI == hemoData.value(forKey: "patientID") as? String){
                    let hemo = hemoData.value(forKey: "hemoglobin_value") as! Float
//                    hemoglobinValue.text = String(format: "%.1f", hemo)
                    if (hemoData.value(forKey: "date") != nil){
                        let d = hemoData.value(forKey: "date") as! NSDate
                        hemoglobinValue.text = String(format: "%.1f", hemo)
                        hemoUpdatedDate.text = "\(d)"
                        hemoglValue = String(format: "%.1f", hemo)
                        hemobloginDate = "\(d)"
                    }
                }
            }
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    /**
     When the user clicked on back button app will be navigating to the Dashboard view controller
     */
    @IBAction func backButtonClicked(_ sender: Any) {
        let name = UserDefaults.standard.object(forKey: "username") as! String
//        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = UHI
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Check if the blutooth is enabled or not, if not then it will navigate to settings page
     */
    @IBAction func bluetoothBtnClicked(_ sender: Any) {
        manager          = CBCentralManager()
        manager.delegate = self
    }
    /**
     Navigating to Patient profile Blood pressure screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func bpviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BloodPressureVC") as! BloodPressureVC
        if (bloodPressureValue != ""){
             vc.bp = bloodPressureValue
        }else{
            vc.bp = "No Data"
        }
        vc.d = bloodPressureDate
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to Patient profile Temperature screen for updating vital alerts and medication information
     - Parameters:
            - guster: sending guesture view
     */
    @objc func tempviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TemperatureVC") as! TemperatureVC
        if (temperatureValue != ""){
             vc.te = temperatureValue
        }else{
            vc.te = "No Data"
        }
        vc.d = temperatureDate
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to Patient profile pulseoxi screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func oxiviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PulseOxiVC") as! PulseOxiVC
        if (pulseoxiValue != ""){
            vc.p = pulseoxiValue
        }else{
            vc.p = "No Data"
        }
        vc.d = pulseoxiDate
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to Patient profile Glucose screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func glucoseTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GlucoseVC") as! GlucoseVC
        if (glucValue != ""){
             vc.g = glucValue
        }else {
             vc.g = "No Data"
        }
        vc.d = glucoseDate
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to Patient profile Heart rate screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func heartRateTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HeartRateVC") as! HeartRateVC
        if (heartValue != ""){
            vc.h = heartValue
        }else {
            vc.h = "No Data"
        }
        vc.d = heartDate
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Navigating to Patient profile Hemoglobin screen for updating vital alerts and medication information
     - Parameters:
        - guster: sending guesture view
     */
    @objc func hemoglobinTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HemoglobinVC") as! HemoglobinVC
        if (hemoglValue != ""){
            vc.hemo = hemoglValue
        }else{
            vc.hemo = "No Data"
        }
        vc.d = hemobloginDate
        navigationController?.pushViewController(vc, animated: true)
    }
    /**
     Bluetooth connection updates
     - Parameters:
        - central: CBCentral Manager delegate function
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager)
    {
        if central.state == .poweredOn
        {
            print("Searching for BLE Devices")
            bluetoothBtn.isSelected = true
            bluetoothBtn.setImage(UIImage(named: "bluetooth_green"), for: .selected)
            // Scan for peripherals if BLE is turned on
        }
        else
        {
            // Can have different conditions for all states if needed - print generic message for now, i.e. Bluetooth isn't On
            bluetoothBtn.isSelected = false
            print("Bluetooth switched off or not initialized")
            bluetoothBtn.setImage(UIImage(named: "bluetooth_offgray"), for: .normal)
            
            let alertController = UIAlertController (title: "Bluetooth Off", message: "In order to connect your BLE devices, please switch ON bluetooth.", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
}
