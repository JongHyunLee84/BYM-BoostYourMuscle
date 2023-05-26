//
//  AddedWorkoutTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

class AddProgramTableViewCell: UITableViewCell {
    
    var exerciseVM: ExerciseViewModel?
    
    private func uiLabelWillReturned(_ title: String) -> UILabel {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 17)
        lb.text = title
        lb.textAlignment = .center
        return lb
    }

    private lazy var workoutNameLabel: UILabel = uiLabelWillReturned("Name")
    private lazy var targetLabel: UILabel = uiLabelWillReturned("Target")
    private lazy var setsLabel: UILabel = uiLabelWillReturned("Sets")
    
    private lazy var stackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [workoutNameLabel, targetLabel, setsLabel])
        stv.axis = .horizontal
        stv.distribution = .fillEqually
        return stv
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupUI()
        }

    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    func setupUI() {
        guard let exerciseVM else { return }
        workoutNameLabel.text = exerciseVM.returnName()
        targetLabel.text = exerciseVM.returnTarget()
        setsLabel.text = exerciseVM.returnSets()
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
    }

}
