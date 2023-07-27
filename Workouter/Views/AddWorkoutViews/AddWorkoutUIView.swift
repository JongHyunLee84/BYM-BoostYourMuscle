//
//  AddWorkoutUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/05/27.
//

import SnapKit
import UIKit

final class AddWorkoutUIView: BaseUIView {
    
    let workoutNameLabel: UILabel = UIFactory.uiLabelWillReturned(title: "Workout Name:")
    let addWorkoutButton: UIButton = UIFactory.uiButtonWillReturned(title: "Add")
    let workoutNameTF: UITextField = UIFactory.uiTextFieldWillReturned(placeholder: "ex. Bench Press")
    let targetLabel: UILabel = UIFactory.uiLabelWillReturned(title: "Target:")
    let targetPickerView: UIPickerView = UIPickerView()
    let restLabel: UILabel = UIFactory.uiLabelWillReturned(title: "Rest Time:")
    let restTimeTF: UITextField = UIFactory.uiTextFieldWillReturned(text: "60", type: .numberPad)
    let secLabel: UILabel = UIFactory.uiLabelWillReturned(title: "sec")
    let minusButton: UIButton = UIFactory.uiButtonWillReturned(title: "-10", fontSize: 15)
    let plusButton: UIButton = UIFactory.uiButtonWillReturned(title: "+10", fontSize: 15)
    let setsLabel: UILabel = UIFactory.uiLabelWillReturned(title: "Sets:")
    let setsWeightTF: UITextField = UIFactory.uiTextFieldWillReturned(text: "60", type: .decimalPad)
    let kgLabel: UILabel = UIFactory.uiLabelWillReturned(title: "kg")
    let setsRepsTF: UITextField = UIFactory.uiTextFieldWillReturned(text: "10", type: .numberPad)
    let repsLabel: UILabel = UIFactory.uiLabelWillReturned(title: "reps")
    let addSetButton: UIButton = UIFactory.uiButtonWillReturned(title: "Add", fontSize: 15)
    let tableView: UITableView = UITableView()
    lazy var minusAndPlusSTV: UIStackView = UIFactory.uiStackViewWillReturned(views: [minusButton, plusButton])
    
    // MARK: - Rx로 TFDelegate 대체 위해서 모아놓음
    lazy var textFieldList = [workoutNameTF, restTimeTF, setsWeightTF, setsRepsTF]
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHierarchy() {
        [workoutNameLabel, addWorkoutButton, workoutNameTF, targetLabel, targetPickerView, restLabel, restTimeTF, secLabel, minusAndPlusSTV, setsLabel, setsWeightTF, kgLabel, setsRepsTF, repsLabel, addSetButton, tableView].forEach { view in
            addSubview(view)
        }
    }
    
    override func setupConstraints() {
        [workoutNameLabel, targetLabel, restLabel, setsLabel].forEach { view in
            view.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(20)
            }
        }
        [workoutNameLabel, addWorkoutButton].forEach { view in
            view.snp.makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(30)
            }
        }
        [workoutNameTF, targetPickerView].forEach { view in
            view.snp.makeConstraints { make in
                make.width.equalToSuperview().multipliedBy(0.8)
                make.centerX.equalToSuperview()
            }
        }
        [restTimeTF, minusAndPlusSTV].forEach { view in
            view.snp.makeConstraints { make in
                make.top.equalTo(restLabel.snp.bottom).offset(20)
            }
        }
        [secLabel, minusAndPlusSTV].forEach { view in
            view.snp.makeConstraints { make in
                make.bottom.equalTo(restTimeTF.snp.bottom)
            }
        }
        [setsWeightTF, setsRepsTF, addSetButton].forEach { view in
            view.snp.makeConstraints { make in
                make.top.equalTo(setsLabel.snp.bottom).offset(25)
            }
        }
        [kgLabel, setsRepsTF, repsLabel, addSetButton].forEach { view in
            view.snp.makeConstraints { make in
                make.bottom.equalTo(setsWeightTF.snp.bottom)
            }
        }
        addWorkoutButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(40)
        }
        workoutNameTF.snp.makeConstraints { make in
            make.top.equalTo(workoutNameLabel.snp.bottom).offset(30)
            make.height.equalTo(30)
        }
        targetLabel.snp.makeConstraints { make in
            make.top.equalTo(workoutNameTF.snp.bottom).offset(25)
        }
        targetPickerView.snp.makeConstraints { make in
            make.top.equalTo(targetLabel.snp.bottom).offset(10)
            make.height.equalTo(100)
        }
        restLabel.snp.makeConstraints { make in
            make.top.equalTo(targetPickerView.snp.bottom).offset(25)
        }
        restTimeTF.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(100)
            make.trailing.equalTo(secLabel.snp.leading)
            make.width.equalTo(50)
        }
        secLabel.snp.makeConstraints { make in
            make.trailing.equalTo(minusAndPlusSTV.snp.trailing).inset(55)
        }
        minusAndPlusSTV.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(55)
        }
        setsLabel.snp.makeConstraints { make in
            make.top.equalTo(restTimeTF.snp.bottom).offset(25)
        }
        setsWeightTF.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(60)
            make.trailing.equalTo(kgLabel.snp.leading)
            make.width.equalTo(40)
        }
        kgLabel.snp.makeConstraints { make in
            make.trailing.equalTo(setsRepsTF.snp.trailing).inset(100)
        }
        setsRepsTF.snp.makeConstraints { make in
            make.trailing.equalTo(repsLabel.snp.leading)
            make.width.equalTo(40)
        }
        addSetButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(40)
            make.width.equalTo(40)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(setsWeightTF.snp.bottom).offset(25)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

import SwiftUI

#if canImport(SwiftUI) && DEBUG

struct AddWorkoutViewPreview<View: UIView>: UIViewRepresentable {
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
struct AddWorkoutViewPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = AddWorkoutUIView()
            return vc
        }
    }
}
