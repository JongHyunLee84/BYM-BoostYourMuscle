//
//  AddProgramUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/05/24.
//

import UIKit
final class AddProgramUIView: UIView {
    
    var addWorkoutButtonAction: (() -> Void)?
    var searchWorkoutButtonAction: (() -> Void)?
    var programVM: ProgramViewModel?
    lazy var tableview: UITableView = {
        let tv = UITableView()
        tv.rowHeight = 70
        return tv
    }()
    private lazy var programNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Program Name"
        lb.font = .boldSystemFont(ofSize: 21)
        return lb
    }()
    
    lazy var programNameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "ex. Push Day"
        tf.autocapitalizationType = .none
        tf.delegate = self
        return tf
    }()
    
    private func uiButtonWillReturned(title t: String) -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle(t, for: .normal)
        bt.setTitleColor(.black, for: .normal)
        bt.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        bt.backgroundColor = .opaqueSeparator
        bt.layer.cornerRadius = 8
        bt.layer.masksToBounds = true
        return bt
    }
    private lazy var addWorkoutButton: UIButton = {
        let bt = uiButtonWillReturned(title: "Add Workout")
        bt.addTarget(self, action: #selector(addWorkoutButtonDidTapped), for: .touchUpInside)
        return bt
    }()
    private lazy var searchWorkoutButton: UIButton = {
        let bt = uiButtonWillReturned(title: "Search Workout")
        bt.addTarget(self, action: #selector(searchWorkoutButtonDidTapped), for: .touchUpInside)
        return bt
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [addWorkoutButton, searchWorkoutButton])
        stv.axis = .horizontal
        stv.spacing = 25
        stv.distribution = .fillEqually
        return stv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupForKeyBoard()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
        setupForKeyBoard()
    }
    
    @objc private func addWorkoutButtonDidTapped() {
        if let closure = addWorkoutButtonAction {
            closure()
        }
    }
    
    @objc private func searchWorkoutButtonDidTapped() {
        if let closure = searchWorkoutButtonAction {
            closure()
        }
    }
    
    private func         setupConstraints() {
        self.backgroundColor = .white
        [programNameLabel, programNameTF, buttonsStackView].forEach { view in
            addSubview(view)
        }
        addSubview(tableview)
        programNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        programNameTF.snp.makeConstraints { make in
            make.top.equalTo(programNameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(programNameTF.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        tableview.snp.makeConstraints { make in
            make.top.equalTo(buttonsStackView.snp.bottom).offset(20)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    // 뷰 아무 곳 터치시 키보드 내리기
    private func setupForKeyBoard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        self.addGestureRecognizer(tap)
    }
    
    
}

extension AddProgramUIView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text else { return }
        programVM?.setName(name)
    }
    
}

import SwiftUI

#if canImport(SwiftUI) && DEBUG
struct AddProgramViewPreview<View: UIView>: UIViewRepresentable {
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
struct AddProgramPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = AddProgramUIView()
            return vc
        }
    }
}
