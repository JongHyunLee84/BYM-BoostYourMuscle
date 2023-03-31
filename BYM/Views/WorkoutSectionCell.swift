//
//  WorkoutSectionCell.swift
//  BYM
//
//  Created by 이종현 on 2023/03/31.
//

import UIKit

class WorkoutSectionCell: UITableViewCell {

    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var triangleImageView: UIImageView!
    //    private var isExtand: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
