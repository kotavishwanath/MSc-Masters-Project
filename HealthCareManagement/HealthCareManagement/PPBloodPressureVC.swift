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
    @IBOutlet weak var submitbtn: UIButton!
    
    var bpValue = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = bpValue
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
    }
    @IBAction func beforMealClicked(_ sender: Any) {
    }
    @IBAction func afterMealClicked(_ sender: Any) {
    }
    
    @IBAction func addMedicineButton(_ sender: Any) {
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func submitButtonClicked(_ sender: Any) {
    }
    
}
