//
//  DashboardViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 21/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func healthStatusButton(_ sender: Any) {
    }
    @IBAction func emergencyButton(_ sender: Any) {
    }
    @IBAction func pillboxButton(_ sender: Any) {
    }
    @IBAction func monitorButton(_ sender: Any) {
    }
    @IBAction func appointmentBookingButton(_ sender: Any) {
        
        self.navigationController?.pushViewController(CalenderVC(), animated: true)
        
        //self.present(CalenderVC(), animated: true, completion: nil)
    }
    @IBAction func telemedicineButton(_ sender: Any) {
    }
}
