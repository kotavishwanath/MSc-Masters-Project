//
//  PPTemperatureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class PPTemperatureVC: UIViewController {
    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var alertMaxValue: UITextField!
    @IBOutlet weak var alertMinValue: UITextField!
    @IBOutlet weak var goalValue: UITextField!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var timesADay: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        beforeMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
        afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
        
    }
    
    @IBAction func backButton(_ sender: Any) {
    }
    @IBAction func beforeMealClicked(_ sender: Any) {
    }
    @IBAction func afterMealClicked(_ sender: Any) {
    }
    @IBAction func addMedicineButton(_ sender: Any) {
    }
    @IBAction func submitButtonClicked(_ sender: Any) {
    }
    
}
