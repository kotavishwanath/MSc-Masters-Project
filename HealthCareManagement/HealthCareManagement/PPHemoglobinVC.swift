//
//  PPHemoglobinVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 20/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class PPHemoglobinVC: UIViewController {

    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var patientUHI: UILabel!
    @IBOutlet weak var doctorNotes: UITextView!
    @IBOutlet weak var medicineName: UITextField!
    @IBOutlet weak var timesPerDay: UITextField!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    @IBOutlet weak var submitbtn: UIButton!
    
    var hemo = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        patientUHI.text = (UserDefaults.standard.object(forKey: "PatientUHINumber") as! String)
        currentValue.text = hemo
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
    }
    
    @IBAction func addMedication(_ sender: Any) {
    }
    @IBAction func backBtnClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PatientProfileVC") as! PatientProfileVC
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func submitBtnClicked(_ sender: Any) {
    }
    
}
