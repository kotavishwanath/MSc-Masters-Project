//
//  MonitorDashboardVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 12/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class MonitorDashboardVC: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        let guster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.bpviewTapped(_:)))
        
        bpView.isUserInteractionEnabled = true
        bpView.addGestureRecognizer(guster)
        
//        TemperatureVC
        let tempGuster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.tempviewTapped(_:)))
        
        temperatureView.isUserInteractionEnabled = true
        temperatureView.addGestureRecognizer(tempGuster)
        
//        PulseOxiVC
        let oxiGuster = UITapGestureRecognizer (target: self, action: #selector(MonitorDashboardVC.oxiviewTapped(_:)))
        
        pluseOxiView.isUserInteractionEnabled = true
        pluseOxiView.addGestureRecognizer(oxiGuster)
        
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let name = UserDefaults.standard.object(forKey: "username") as! String
        let uhi = UserDefaults.standard.object(forKey: "UHI") as! String
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
        vc.name = name
        vc.uhinumber = uhi
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func bluetoothBtnClicked(_ sender: Any) {
    }
    
    @objc func bpviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BloodPressureVC") as! BloodPressureVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func tempviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TemperatureVC") as! TemperatureVC
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func oxiviewTapped(_ guster: UITapGestureRecognizer){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PulseOxiVC") as! PulseOxiVC
        navigationController?.pushViewController(vc, animated: true)
    }

}
