//
//  ProgramListTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit

// edit 버튼이 눌렸을 때 프로그램 편집 뷰로 넘어가야함.
protocol ProgramListViewDelegate: AnyObject {
    func editButtonTapped()
}

final class ProgramListTableViewCell: UITableViewCell {

    weak var delegate: ProgramListViewDelegate?
    
    @IBOutlet weak var programTitleLabel: UILabel!
    @IBAction func editButtonTapped(_ sender: UIButton) {
        delegate?.editButtonTapped()
    }
    
    func setupCell(_ vm: ProgramViewModel) {
        programTitleLabel.text = vm.title
    }
    
}
