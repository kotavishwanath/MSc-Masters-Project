//
//  PatientsListCell.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 26/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit

class PatientsListCell: UITableViewCell {
    
    @IBOutlet weak var patientsUHINumber: UILabel!
    @IBOutlet weak var patientsDOBLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientProfilePicture: UIImageView!
    
    func setPatient(info: PatientsList){
        patientsUHINumber.text = info.UHI
        patientsDOBLabel.text = info.dob
        patientNameLabel.text = info.name
        patientProfilePicture.image = info.profileImage
    }

}
