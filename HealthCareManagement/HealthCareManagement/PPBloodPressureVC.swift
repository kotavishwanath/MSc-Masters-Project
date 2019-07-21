//
//  PPBloodPressureVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class PPBloodPressureVC: UIViewController {

    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var systolicMaxValue: UITextField!
    @IBOutlet weak var diastolicMaxValue: UITextField!
    @IBOutlet weak var systolicMinValue: UITextField!
    @IBOutlet weak var diastolicMinValue: UITextField!
    @IBOutlet weak var goalSystolicValue: UITextField!
    @IBOutlet weak var goalDiastolicValue: UITextField!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var numberOftimes: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func beforMealClicked(_ sender: Any) {
    }
    @IBAction func afterMealClicked(_ sender: Any) {
    }
    
    @IBAction func addMedicineButton(_ sender: Any) {
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
    }
    @IBAction func submitButtonClicked(_ sender: Any) {
    }
    
}
