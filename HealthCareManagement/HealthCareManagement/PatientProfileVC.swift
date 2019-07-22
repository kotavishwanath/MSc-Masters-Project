//
//  PatientProfileVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class PatientProfileVC: UIViewController {

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
    
    var bloodPressureValue = String()
    var temperatureValue = String()
    var pulseoxiValue = String()
    var glucoseValue = String()
    var heartRateValue = String()
    var hemoValue = String()
    
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
            
            for bpData in BPInfo{
                if (UHI == bpData.value(forKey: "patientID") as? String){
                    let systolicValue = bpData.value(forKeyPath: "systolic") as! Int
                    let diastolicValue = bpData.value(forKeyPath: "diastolic") as! Int
                    self.bpData.text = "\(systolicValue)/\(diastolicValue)"
                    bloodPressureValue = "Current Value: \(systolicValue)/\(diastolicValue) mmHG"
                    let d = bpData.value(forKey: "date") as! NSDate
                    bpUpdatedDate.text = "\(d)"
                }
            }
            
            for tempData in tempInfo{
                /* let i:Int = 0
                 tempData.setValue(i, forKey: "temprature_info")*/
                if (UHI == tempData.value(forKey: "patientID") as? String){
                    let temp = tempData.value(forKey: "temprature_info") as! Float
                    self.tempData.text = String(format: "%.1f", temp)
                    temperatureValue = "Current Value: \( String(format: "%.1f", temp)) °F"
                    let d = tempData.value(forKey: "date") as! NSDate
                    tempUpdatedDate.text = "\(d)"
                }
            }
            
            for pulseData in pluseOxiInfo{
                if (UHI == pulseData.value(forKey: "patientID") as? String){
                    let pulse = pulseData.value(forKey: "pulseoxi_value") as! Float
                    pulseOxiData.text = String(format: "%.1f", pulse)
                    pulseoxiValue = "Current Value: \(String(format: "%.1f", pulse)) %"
                    let d = pulseData.value(forKey: "date") as! NSDate
                    pulseOxiUpdatedDate.text = "\(d)"
                }
            }
            
            for glucoseData in glucoseInfo{
                if (UHI == glucoseData.value(forKey: "patientID") as? String){
                    let glucose = glucoseData.value(forKey: "glucose_value") as! Int
                    self.glucoseData.text = "\(glucose)"
                    glucoseValue = "Current Value: \(glucose) mg/dl"
                    let d = glucoseData.value(forKey: "date") as! NSDate
                    glucoseUpdatedDate.text = "\(d)"
                }
            }
            
            for heartData in heartRateInfo{
                if (UHI == heartData.value(forKey: "patientID") as? String){
                    let rate = heartData.value(forKey: "heartrate_value") as! Int
                    heartRateData.text = "\(rate)"
                    heartRateValue = "Current Value: \(rate) bpm"
                    let d = heartData.value(forKey: "date") as! NSDate
                    heartRateUpdatedDate.text = "\(d)"
                }
            }
            
            for hemoData in hemoInfo{
                if (UHI == hemoData.value(forKey: "patientID") as? String){
                    let hemo = hemoData.value(forKey: "hemoglobin_value") as! Float
                    self.hemoData.text = String(format: "%.1f", hemo)
                    hemoValue = "Current Value: \(String(format: "%.1f", hemo)) %"
                    let d = hemoData.value(forKey: "date") as! NSDate
                    hemoUpdatedDate.text = "\(d)"
                }
            }
            
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @objc func bpviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPBloodPressureVC") as! PPBloodPressureVC
        vc.bpValue = bloodPressureValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tempviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPTemperatureVC") as! PPTemperatureVC
        vc.tempValue = temperatureValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func oxiviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPPulseOxiMeterVC") as! PPPulseOxiMeterVC
        vc.oxiValue = pulseoxiValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func glucoseTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPGlucoseVC") as! PPGlucoseVC
        vc.glucose = glucoseValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func heartRateTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPHeartRateVC") as! PPHeartRateVC
        vc.heartRate = heartRateValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func hemoglobinTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PPHemoglobinVC") as! PPHemoglobinVC
        vc.hemo = hemoValue
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DoctorsViewController") as! DoctorsViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
