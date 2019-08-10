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

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var chartsTitle: UILabel!
    
    var tempDataArrey = [Float]()
    var pulseDataArray = [Float]()
    var glucoseDataArray = [Int]()
    var hearrateDataArray = [Int]()
    var hemoglobinDataArray = [Float]()
    
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
        }
         chartsTitle.text = "\(screen) Report"
        
    }
    
    
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
    
    @IBAction func closeBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HealthStatusVC") as! HealthStatusVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
