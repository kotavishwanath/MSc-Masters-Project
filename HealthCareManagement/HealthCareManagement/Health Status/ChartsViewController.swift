//
//  ChartsViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 10/08/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: UIViewController {
    /**
     Outlet connections from the UI and is self describing variable names
     */
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var chartsTitle: UILabel!
    
    ///Getting the temperature data values
    var tempDataArrey = [Float]()
    ///Getting the pulse oxi data values
    var pulseDataArray = [Float]()
    ///Getting the Glucose data values
    var glucoseDataArray = [Int]()
    ///Getting the Heart rate data values
    var hearrateDataArray = [Int]()
    ///Getting the Hemoglobin data values
    var hemoglobinDataArray = [Float]()
    
    var systolicAry = [Int]()
    var diastolicAry = [Int]()
    ///Screen name 
    var screen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (screen == "Temperature"){
            print("Temperature Data: \(tempDataArrey)")
            temperatureChartValues(set: tempDataArrey)
        } else if (screen == "PulseOxi"){
            print("Temperature Data: \(pulseDataArray)")
            pulseOxiChartValues(set: pulseDataArray)
        } else if (screen == "Glucose"){
            print("Glucose Data: \(glucoseDataArray)")
            glucoseChartValues(set: glucoseDataArray)
        } else if (screen == "HeartRate"){
            print("Heart Rate Data: \(hearrateDataArray)")
            heartrateChartValues(set: hearrateDataArray)
        } else if (screen == "Hemoglobin"){
            print("Hemoglobin Data: \(hemoglobinDataArray)")
            hemoChartValues(set: hemoglobinDataArray)
        } else if (screen == "BloodPressure"){
             bloodpressureChartValues(set1: systolicAry, set2: diastolicAry)
        }
         chartsTitle.text = "\(screen) Report"
    }
    
    /**
     Ploting the temperature graph
     */
    func temperatureChartValues(set: [Float]){
        let temperatureAry = set
        let values = (0..<temperatureAry.count).map { (i) -> ChartDataEntry in
            let val = Double(temperatureAry[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        let set1 = LineChartDataSet(entries: values, label: "Temperature (°F)")
        let data = LineChartData(dataSet: set1)
        self.chartView.chartDescription?.text = "Temperature Info"
        self.chartView.data = data
     }
    /**
     Ploting the pulse oxi graph
     */
    func pulseOxiChartValues(set: [Float]){
        let pulseAry = set
        let values = (0..<pulseAry.count).map { (i) -> ChartDataEntry in
            let val = Double(pulseAry[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        let set1 = LineChartDataSet(entries: values, label: "PulseOxi (%)")
        let data = LineChartData(dataSet: set1)
        self.chartView.chartDescription?.text = "PulseOxi Info"
        self.chartView.data = data
    }
    /**
     Ploting the Glucose graph
     */
    func glucoseChartValues(set: [Int]){
        let glucoseAry = set
        let values = (0..<glucoseAry.count).map { (i) -> ChartDataEntry in
            let val = Double(glucoseAry[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        let set1 = LineChartDataSet(entries: values, label: "Glucose (mg/dl)")
        let data = LineChartData(dataSet: set1)
        self.chartView.chartDescription?.text = "Glucose Info"
        self.chartView.data = data
    }
    /**
     Ploting the Heart rate graph
     */
    func heartrateChartValues(set: [Int]){
        let heartbeatAry = set
        let values = (0..<heartbeatAry.count).map { (i) -> ChartDataEntry in
            let val = Double(heartbeatAry[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        let set1 = LineChartDataSet(entries: values, label: "Heart Rate (BPM)")
        let data = LineChartData(dataSet: set1)
        self.chartView.chartDescription?.text = "Heart Rate"
        self.chartView.data = data
    }
    /**
     Ploting the Hemoglobin graph
     */
    func hemoChartValues(set: [Float]){
        let hemoAry = set
        let values = (0..<hemoAry.count).map { (i) -> ChartDataEntry in
            let val = Double(hemoAry[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        let set1 = LineChartDataSet(entries: values, label: "Hemoglobin (%)")
        let data = LineChartData(dataSet: set1)
        self.chartView.chartDescription?.text = "Hemoglobin Info"
        self.chartView.data = data
    }
    /**
     Ploting the Blood pressure graph
     */
    func bloodpressureChartValues(set1: [Int], set2: [Int]){
        let sysAry = set1
        let diaAry = set2
        
        let values = (0..<sysAry.count).map { (i) -> ChartDataEntry in
            let val = Double(sysAry[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set1 = LineChartDataSet(entries: values, label: "Systolic")
        set1.setColor(UIColor.green)
        set1.setCircleColor(UIColor.green)
        
        let values1 = (0..<diaAry.count).map { (i) -> ChartDataEntry in
            let val = Double(diaAry[i])
            return ChartDataEntry(x: Double(i), y: val)
        }
        
        let set2 = LineChartDataSet(entries: values1, label: "Diastolic")
       
        var dataSetss: [LineChartDataSet] = [LineChartDataSet]()
        dataSetss.append(set1)
        dataSetss.append(set2)

        let data = LineChartData(dataSets: dataSetss)
        
        self.chartView.chartDescription?.text = "Blood Pressure Info"
        self.chartView.data = data
    }
    /**
     Close button is used for navigating to the Health status screen
     */
    @IBAction func closeBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HealthStatusVC") as! HealthStatusVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
