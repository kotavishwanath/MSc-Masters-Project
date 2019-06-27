//
//  DoctorsViewController.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 27/06/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class DoctorsViewController: UIViewController {
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var GMCNumber: UILabel!
    @IBOutlet weak var submitbtn: UIButton!
    @IBOutlet weak var uhinumberTxt: UITextField!
    
    var doctorname: String = ""
    var gmcNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitbtn.layer.borderWidth = 1
        submitbtn.layer.borderColor = UIColor.blue.cgColor
        submitbtn.layer.cornerRadius = 4.0
        
        doctorName.text = doctorname
        GMCNumber.text = gmcNumber
        
        uhinumberTxt.layer.borderColor = UIColor.black.cgColor
        uhinumberTxt.layer.borderWidth = 1
        uhinumberTxt.layer.cornerRadius = 5.0
        
    }
    
    @IBAction func submitButton(_ sender: Any) {
        
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }

}
