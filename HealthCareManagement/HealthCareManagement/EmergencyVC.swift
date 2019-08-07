//
//  EmergencyVC.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 07/08/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class EmergencyVC: UIViewController {

    @IBOutlet weak var close: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sosBtn(_ sender: Any) {
        guard let number = URL(string: "tel://" + "999") else { return }
        UIApplication.shared.open(number)
    }
    
    @IBAction func needHelpBtn(_ sender: Any) {
        //import data form core
        guard let number = URL(string: "tel://" + "999") else { return }
        UIApplication.shared.open(number)
    }

}
