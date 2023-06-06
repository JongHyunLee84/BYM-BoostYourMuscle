//
//  WorkoutUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/06.
//

import UIKit

class WorkoutUIView: UIView {
    
    lazy var editButton: UIButton = CommonUI.uiButtonWillReturned(title: "Edit", fontSize: 20, target: self, action: #selector(editButtonDidTapped))
    lazy var doneButton: UIButton = CommonUI.uiButtonWillReturned(title: "Done", fontSize: 20, target: self, action: #selector(doneButtonDidTapped))
    lazy var mainTimerLabel: UILabel = CommonUI.uiLabelWillReturned(title: "00 : 00 : 00", size: 35, weight: .semibold)
    lazy var startStopButton: UIButton = CommonUI.uiImageButtonWillReturned("pause.circle", size: 36, weight: .semibold, scale: .default, target: self, action: #selector(startStopButtonDidTapped))
    lazy var tableView: UITableView = UITableView()
    // Rest Views
    lazy var restLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Rest", size: 15)
    lazy var soundButton: UIButton = CommonUI.uiImageButtonWillReturned("speaker.wave.2", target: self, action: #selector(soundButtonDidTapped))
    lazy var restTimerLabel: UILabel = CommonUI.uiLabelWillReturned(title: "00 sec", size: 30, weight: .medium, alignment: .center)
    lazy var minusButton: UIButton = CommonUI.uiButtonWillReturned(title: "-10", fontSize: 18, target: self, action: #selector(minusButtonDidTapped))
    lazy var resetButton: UIButton = CommonUI.uiButtonWillReturned(title: "Reset", target: self, action: #selector(resetButtonDidTapped))
    lazy var plusButton: UIButton = CommonUI.uiButtonWillReturned(title: "+10", fontSize: 18, target: self, action: #selector(plusButtonDidTapped))
    
    @objc private func editButtonDidTapped() {}
    @objc private func doneButtonDidTapped() {}
    @objc private func startStopButtonDidTapped() {}
    @objc private func soundButtonDidTapped() {}
    @objc private func minusButtonDidTapped() {}
    @objc private func resetButtonDidTapped() {}
    @objc private func plusButtonDidTapped() {}
}
