//
//  WorkoutRowCell.swift
//  BYM
//
//  Created by 이종현 on 2023/03/31.
//

import UIKit

class WorkoutRowCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var repsLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
