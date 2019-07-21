//
//  PPPulseOxiMeterVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class PPPulseOxiMeterVC: UIViewController {
    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var alertMinValue: UITextField!
    @IBOutlet weak var goal: UITextField!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var howmanyTimes: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func beforeMealBtnClicked(_ sender: Any) {
    }
    @IBAction func afterMealBtnClicked(_ sender: Any) {
    }
    @IBAction func addMedication(_ sender: Any) {
    }
    @IBAction func backButtonClicked(_ sender: Any) {
    }
    @IBAction func submitButtonClicked(_ sender: Any) {
    }
}
