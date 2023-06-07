//
//  WorkoutUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/06.
//

import UIKit

class WorkoutUIView: UIView {
    
    var editButtonAction: (()->Void)?
    var doneButtonAction: (()->Void)?
    var startStopButtonAction: (()->Void)?
    var soundButtonAction: (()->Void)?
    var resetButtonAction: ((UIButton)->Void)?
    
    lazy var editButton: UIButton = CommonUI.uiButtonWillReturned(title: "Edit", fontSize: 20, target: self, action: #selector(editButtonDidTapped), backgroundColor: .clear)
    lazy var doneButton: UIButton = CommonUI.uiButtonWillReturned(title: "Done", fontSize: 20, target: self, action: #selector(doneButtonDidTapped), backgroundColor: .clear)
    lazy var mainTimerLabel: UILabel = CommonUI.uiLabelWillReturned(title: "00 : 00 : 00", size: 35, weight: .semibold)
    lazy var startStopButton: UIButton = CommonUI.uiImageButtonWillReturned("pause.circle", size: 36, weight: .semibold, scale: .default, target: self, action: #selector(startStopButtonDidTapped))
    lazy var tableView: UITableView = UITableView()
    // Rest Views
    lazy var restLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Rest", size: 15)
    lazy var soundButton: UIButton = CommonUI.uiImageButtonWillReturned("speaker.wave.2", target: self, action: #selector(soundButtonDidTapped))
    lazy var restTimerLabel: UILabel = CommonUI.uiLabelWillReturned(title: "00 sec", size: 30, weight: .medium, alignment: .center)
    lazy var minusButton: UIButton = CommonUI.uiButtonWillReturned(title: "-10", fontSize: 18, target: self, action: #selector(restButtonDidTapped(_:)), tag: 1)
    lazy var resetButton: UIButton = CommonUI.uiButtonWillReturned(title: "Reset", target: self, action: #selector(restButtonDidTapped(_:)), tag: 2)
    lazy var plusButton: UIButton = CommonUI.uiButtonWillReturned(title: "+10", fontSize: 18, target: self, action: #selector(restButtonDidTapped(_:)), tag: 3)
    lazy var editDoneBtsSTV: UIStackView = CommonUI.uiStackViewWillReturned(views: [editButton, doneButton], alignment: .fill, distribution: .equalSpacing)
    lazy var mainTimerSTV: UIStackView = CommonUI.uiStackViewWillReturned(views: [mainTimerLabel, startStopButton], distribution: .fill)
    lazy var restBackgroundView: UIView = UIView()
    lazy var restLabelAndSoundBTSTV: UIStackView = CommonUI.uiStackViewWillReturned(views: [restLabel, soundButton], distribution: .fill)
    lazy var restBTsSTV: UIStackView = CommonUI.uiStackViewWillReturned(views: [minusButton, resetButton, plusButton], distribution: .fillEqually)
    lazy var restTimerAndResetBTsSTV: UIStackView = CommonUI.uiStackViewWillReturned(views: [restTimerLabel, restBTsSTV], distribution: .fill)
    
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupUI()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setupUI()
        }
    
    private func setupUI() {
        self.backgroundColor = .white
        // UI
        restBackgroundView.backgroundColor = .lightGray
        
        [editDoneBtsSTV, mainTimerSTV, tableView, restBackgroundView].forEach { addSubview($0) }
        [restLabelAndSoundBTSTV, restTimerAndResetBTsSTV].forEach { restBackgroundView.addSubview($0) }
        
        editDoneBtsSTV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(15)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(15)
        }
        mainTimerSTV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(65)
            make.top.equalTo(editDoneBtsSTV.snp.bottom).offset(25)
        }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(mainTimerSTV.snp.bottom).offset(25)
        }
        restBackgroundView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(tableView.snp.bottom)
            make.height.equalTo(100)
        }
        restLabelAndSoundBTSTV.snp.makeConstraints { make in
            make.leading.trailing.equalTo(restTimerLabel)
            make.top.equalToSuperview().offset(15)
        }
        restTimerLabel.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
        restTimerAndResetBTsSTV.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(restLabelAndSoundBTSTV.snp.bottom).offset(5)
        }
    }
    
    @objc private func editButtonDidTapped() { editButtonAction?() }
    @objc private func doneButtonDidTapped() { doneButtonAction?() }
    @objc private func startStopButtonDidTapped() { startStopButtonAction?() }
    @objc private func soundButtonDidTapped() { soundButtonAction?() }
    @objc private func restButtonDidTapped(_ sender: UIButton) { resetButtonAction?(sender) }

}

import SwiftUI

#if canImport(SwiftUI) && DEBUG
struct WorkoutUIViewPreview<View: UIView>: UIViewRepresentable {
    let view: View
    
    init(_ builder: @escaping () -> View) {
        view = builder()
    }
    
    // MARK: UIViewRepresentable
    func makeUIView(context: Context) -> UIView {
        return view
    }
    
    func updateUIView(_ view: UIView, context: Context) {
        view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        view.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
#endif
struct WorkoutUIViewPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = WorkoutUIView()
            return vc
        }
    }
}
