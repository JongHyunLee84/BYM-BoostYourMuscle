//
//  AddWorkoutUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/05/27.
//

import UIKit

class AddWorkoutUIView: UIView {
    
    var addWorkoutAction: (() -> Void)?
    var minusButtonAction: ((Int) -> Void)?
    var plusButtonAction: ((Int) -> Void)?
    var setsAddButtonAction: (() -> Void)?
    
    private func uiButtonWillReturned(title t: String, fontSize s: CGFloat? = nil) -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle(t, for: .normal)
        if let s {
            bt.titleLabel?.font = .systemFont(ofSize: s)
        }
        bt.setTitleColor(.black, for: .normal)
        bt.backgroundColor = .opaqueSeparator
        bt.layer.cornerRadius = 8
        bt.layer.masksToBounds = true
        return bt
    }
    private func uiTextFieldWillReturned(placeholder p: String? = nil, text t: String? = nil, tag: Int = 0) -> UITextField {
        let tf = UITextField()
        tf.placeholder = p
        tf.text = t
        tf.font = .systemFont(ofSize: 15, weight: .medium)
        tf.backgroundColor = .quaternarySystemFill
        tf.textAlignment = .center
        tf.layer.cornerRadius = 8
        tf.layer.masksToBounds = true
        tf.tag = tag
        return tf
    }
    private func uiLabelWillReturned(title t: String) -> UILabel {
        let lb = UILabel()
        lb.text = t
        lb.font = .systemFont(ofSize: 15, weight: .medium)
        return lb
    }
    private func uiStackViewWillReturned(views vs: [UIView], alignment ali: UIStackView.Alignment = .center) -> UIStackView {
        let stv = UIStackView(arrangedSubviews: vs)
        stv.axis = .horizontal
        stv.alignment = ali
        stv.spacing = 20
        stv.distribution = .fillEqually
        return stv
    }
    private lazy var workoutNameLabel: UILabel = uiLabelWillReturned(title: "Workout Name:")
    private lazy var addWorkoutButton: UIButton = {
        let bt = uiButtonWillReturned(title: "Add")
        bt.addTarget(self, action: #selector(addWorkoutTapeed), for: .touchUpInside)
        return bt
    }()
    lazy var workoutNameTF: UITextField = uiTextFieldWillReturned(placeholder: "ex. Bench Press", tag: 1)
    private lazy var targetLabel: UILabel = uiLabelWillReturned(title: "Target:")
    lazy var targetPickerView: UIPickerView = UIPickerView()
    private lazy var restLabel: UILabel = uiLabelWillReturned(title: "Rest Time:")
    lazy var restTimeTF: UITextField = uiTextFieldWillReturned(text: "60", tag: 2)
    private lazy var secLabel: UILabel = uiLabelWillReturned(title: "sec")
    private lazy var minusButton: UIButton = {
        let bt = uiButtonWillReturned(title: "-10", fontSize: 15)
        bt.addTarget(self, action: #selector(minusButtonTapped), for: .touchUpInside)
        return bt
    }()
    private lazy var plusButton: UIButton = {
        let bt = uiButtonWillReturned(title: "+10", fontSize: 15)
        bt.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return bt
    }()
    private lazy var minusAndPlusSTV: UIStackView = uiStackViewWillReturned(views: [minusButton, plusButton])
    private lazy var setsLabel: UILabel = uiLabelWillReturned(title: "Sets:")
    lazy var setsWeightTF: UITextField = uiTextFieldWillReturned(text: "60")
    private lazy var kgLabel: UILabel = uiLabelWillReturned(title: "kg")
    lazy var setsRepsTF: UITextField = uiTextFieldWillReturned(text: "10")
    private lazy var repsLabel: UILabel = uiLabelWillReturned(title: "reps")
    private lazy var addSetButton: UIButton = {
        let bt = uiButtonWillReturned(title: "Add", fontSize: 15)
        bt.addTarget(self, action: #selector(setsAddButtonTapped), for: .touchUpInside)
        return bt
    }()
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 45
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupForKeyBoard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.backgroundColor = .white
        [workoutNameLabel, addWorkoutButton, workoutNameTF, targetLabel, targetPickerView, restLabel, restTimeTF, secLabel, minusAndPlusSTV, setsLabel, setsWeightTF, kgLabel, setsRepsTF, repsLabel, addSetButton, tableView].forEach { view in
            addSubview(view)
        }
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
    
    // 뷰 아무 곳 터치시 키보드 내리기
        func setupForKeyBoard() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
            tap.cancelsTouchesInView = false
            self.addGestureRecognizer(tap)
        }
    
    @objc private func addWorkoutTapeed() { addWorkoutAction?() }
    @objc private func minusButtonTapped() { minusButtonAction?(0) }
    @objc private func plusButtonTapped() { plusButtonAction?(1)}
    @objc private func setsAddButtonTapped() { setsAddButtonAction?() }
   
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
