//
//  AddWorkoutTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

class AddWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var repsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupUI(_ vm: PSetViewModel, index: Int) {
        numberLabel.text = "\(index + 1) set"
        weightLabel.text = vm.returnWeight()
        repsLabel.text = vm.returnReps()
        
    }

}
