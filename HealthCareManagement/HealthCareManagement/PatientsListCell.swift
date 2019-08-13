//
//  PatientsListCell.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 26/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
/**
 Table view Cell for the patents list table view
 */
class PatientsListCell: UITableViewCell {
    
    @IBOutlet weak var patientsUHINumber: UILabel!
    @IBOutlet weak var patientsDOBLabel: UILabel!
    @IBOutlet weak var patientNameLabel: UILabel!
    @IBOutlet weak var patientProfilePicture: UIImageView!
    /**
     setPatient name is used for updating the cell with the required data
     */
    func setPatient(info: PatientsList){
        patientsUHINumber.text = info.UHI
        patientsDOBLabel.text = info.dob
        patientNameLabel.text = info.name
        patientProfilePicture.image = info.profileImage
    }

}
