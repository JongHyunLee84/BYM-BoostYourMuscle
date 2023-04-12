//
//  SearchWorkoutTableViewCell.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/12.
//

import UIKit

class SearchWorkoutTableViewCell: UITableViewCell {

    @IBOutlet weak var workoutImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var equipmentLabel: UILabel!
    var plusButtonTapped: (() -> Void) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func plusButtonTapped(_ sender: Any) {
        plusButtonTapped()
    }
    

}
