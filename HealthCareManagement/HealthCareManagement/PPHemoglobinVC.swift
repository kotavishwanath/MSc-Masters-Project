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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addMedication(_ sender: Any) {
    }
    @IBAction func backBtnClicked(_ sender: Any) {
    }
    @IBAction func submitBtnClicked(_ sender: Any) {
    }
    
}
