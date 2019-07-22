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
    @IBOutlet weak var submitbtn: UIButton!
    
    var tempValue = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentValue.text = tempValue
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        beforeMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
        afterMealBtn.setImage(UIImage(named: "empty_check"), for: .normal)
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
    }
    
    @IBAction func backButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
        navigationController?.pushViewController(vc, animated: true)
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
