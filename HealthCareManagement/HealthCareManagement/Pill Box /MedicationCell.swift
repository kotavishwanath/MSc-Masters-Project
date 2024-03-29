//
//  MedicationCell.swift
//  HealthCareManagement
//
//  Created by Vishwanath Kota on 29/07/19.
//  Copyright © 2019 University Of Hertfordshire. All rights reserved.
//

import UIKit
/**
 Medication cell view which is used pillbox screen
 */
class MedicationCell: UITableViewCell {
    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var beformeal: UILabel!
    @IBOutlet weak var aftermeal: UILabel!
    @IBOutlet weak var howManyTimesADay: UILabel!
    @IBOutlet weak var beforeMealBtn: UIButton!
    @IBOutlet weak var afterMealBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    /**
     Updating the pill box table view with the medicine name, how many times, before meal and after meal
     */
    func updateUI(info: MedicationList){
        medicineName.text = info.medicineName
        howManyTimesADay.text = "\(info.timesADay)"
        beforeMealBtn.isSelected = info.beforeMeal
        afterMealBtn.isSelected = info.afterMeal
    }

}
