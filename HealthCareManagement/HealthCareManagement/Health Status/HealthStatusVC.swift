//
//  HealthStatusVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 14/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import CoreData

class HealthStatusVC: UIViewController {

    var UHI = String()
    
    @IBOutlet weak var tempView: UIView!
    @IBOutlet weak var pulseoxiView: UIView!
    @IBOutlet weak var glucoseView: UIView!
    @IBOutlet weak var heartRateView: UIView!
    @IBOutlet weak var hemoView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

//        TemperatureVC
        let tempGuster = UITapGestureRecognizer (target: self, action: #selector(HealthStatusVC.tempviewTapped(_:)))
        
        tempView.isUserInteractionEnabled = true
        tempView.addGestureRecognizer(tempGuster)
        
        //        PulseOxiVC
        let oxiGuster = UITapGestureRecognizer (target: self, action: #selector(HealthStatusVC.oxiviewTapped(_:)))
        
        pulseoxiView.isUserInteractionEnabled = true
        pulseoxiView.addGestureRecognizer(oxiGuster)
        
        let glucoseGuster = UITapGestureRecognizer (target: self, action: #selector(HealthStatusVC.glucoseTapped(_:)))
        
        glucoseView.isUserInteractionEnabled = true
        glucoseView.addGestureRecognizer(glucoseGuster)
        
        let heartRateGuster = UITapGestureRecognizer (target: self, action: #selector(HealthStatusVC.heartRateTapped(_:)))
        
        heartRateView.isUserInteractionEnabled = true
        heartRateView.addGestureRecognizer(heartRateGuster)
        
        let hemoglobinGuster = UITapGestureRecognizer (target: self, action: #selector(HealthStatusVC.hemoglobinTapped(_:)))
        
        hemoView.isUserInteractionEnabled = true
        hemoView.addGestureRecognizer(hemoglobinGuster)
        
        //For Reteriving the Blood Pressure Information
        UHI = UserDefaults.standard.object(forKey: "UHI") as! String
        var systolicAry = [Int]()
        var diastolicAry = [Int]()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BloodPressureVitalInfo")
        do{
            let info = try managedContext.fetch(fetchRequest)
            for data in info{
                if (UHI == (data.value(forKey: "patientID") as? String)){
                    systolicAry.append(data.value(forKey: "systolic") as! Int)
                    diastolicAry.append(data.value(forKey: "diastolic") as! Int)
                }
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
//        print("Systolic Arry: \(systolicAry)")
//        print("Diastolic Arry: \(diastolicAry)")
//
        var systolicAryData = [Int]()
        var diastolicAryData = [Int]()
        
        for i in 0..<systolicAry.count{
//            print("Systolic Ary index :\(i) and value :\(systolicAry[i])")
            if (systolicAry[i] != 0){
                systolicAryData.append(systolicAry[i])
                diastolicAryData.append(diastolicAry[i])
            }
        }
        
        print("============================================")
        print("Systolic Arry: \(systolicAryData)")
        print("Diastolic Arry: \(diastolicAryData)")
        
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        let name = UserDefaults.standard.object(forKey: "username") as! String
        //        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = UHI
        navigationController?.pushViewController(vc, animated: true)
    }
    /*
    func temperatureChartsValues(){
        let temperatureAry = [80, 200, 100, 90, 80, 80, 88, 90, 80, 81, 80, 131, 80, 200, 100, 90, 80, 80, 88, 90, 80]
        let values = (0..<temperatureAry.count).map { (i) -> ChartDataEntry in
            let val = Double(temperatureAry[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        let set1 = LineChartDataSet(entries: values, label: "DataSet 1")
        let data = LineChartData(dataSet: set1)
        self.chtView.data = data
    }
     */
    
    
    @objc func tempviewTapped(_ guster: UITapGestureRecognizer){
        var temperatureDataAry = [Float]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequestTemp =
            NSFetchRequest<NSManagedObject>(entityName: "TemperatureVitalInfo")
        do{
            let tempInfo = try managedContext.fetch(fetchRequestTemp)
            for tempData in tempInfo{
                if (UHI == tempData.value(forKey: "patientID") as? String){
                    let val = tempData.value(forKey: "temprature_info") as? Float ?? 0.0
                    if (val != 0 && val > 0){
                        temperatureDataAry.append(val)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChartsViewController") as! ChartsViewController
        vc.tempDataArrey = temperatureDataAry
        vc.screen = "Temperature"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func oxiviewTapped(_ guster: UITapGestureRecognizer){
        var pulseoxiDataAry = [Float]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequestPulseOxi =
            NSFetchRequest<NSManagedObject>(entityName: "PulseOxiInfo")
        do{
            let pluseOxiInfo = try managedContext.fetch(fetchRequestPulseOxi)
            for pulseData in pluseOxiInfo{
                if (UHI == pulseData.value(forKey: "patientID") as? String){
                    let val = pulseData.value(forKey: "pulseoxi_value") as? Float ?? 0.0
                    if (val != 0 && val > 0){
                        pulseoxiDataAry.append(val)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChartsViewController") as! ChartsViewController
        vc.pulseDataArray = pulseoxiDataAry
        vc.screen = "PulseOxi"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func glucoseTapped(_ guster: UITapGestureRecognizer){
        var glucoseDataAry = [Int]()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequestGlucose =
            NSFetchRequest<NSManagedObject>(entityName: "GlucoseInfo")
        do{
            let glucoseInfo = try managedContext.fetch(fetchRequestGlucose)
            for glucoseData in glucoseInfo{
                if (UHI == glucoseData.value(forKey: "patientID") as? String){
                    let val = glucoseData.value(forKey: "glucose_value") as? Int ?? 0
                    if (val != 0 && val > 0){
                        glucoseDataAry.append(val)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChartsViewController") as! ChartsViewController
        vc.glucoseDataArray = glucoseDataAry
        vc.screen = "Glucose"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func heartRateTapped(_ guster: UITapGestureRecognizer){
        var heartDataAry = [Int]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequestHeartRate =
            NSFetchRequest<NSManagedObject>(entityName: "HeartRateInfo")
        do{
            let heartRateInfo = try managedContext.fetch(fetchRequestHeartRate)
            for heartData in heartRateInfo{
                if (UHI == heartData.value(forKey: "patientID") as? String){
                    let val = heartData.value(forKey: "heartrate_value") as? Int ?? 0
                    if (val != 0 && val > 0){
                        heartDataAry.append(val)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChartsViewController") as! ChartsViewController
        vc.hearrateDataArray = heartDataAry
        vc.screen = "HeartRate"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func hemoglobinTapped(_ guster: UITapGestureRecognizer){
        var hemobloginDataAry = [Float]()
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let fetchRequestHemo =
            NSFetchRequest<NSManagedObject>(entityName: "HemoglobinInfo")
        do{
            let hemoInfo = try managedContext.fetch(fetchRequestHemo)
            for hemoData in hemoInfo{
                if (UHI == hemoData.value(forKey: "patientID") as? String){
                    let val = hemoData.value(forKey: "hemoglobin_value") as? Float ?? 0.0
                    if (val != 0 && val > 0){
                        hemobloginDataAry.append(val)
                    }
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChartsViewController") as! ChartsViewController
        vc.hemoglobinDataArray = hemobloginDataAry
        vc.screen = "Hemoglobin"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
