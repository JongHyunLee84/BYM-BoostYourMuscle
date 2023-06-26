//
//  AddProgramUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/05/24.
//

import UIKit
final class AddProgramUIView: BaseUIView {
    
    var addWorkoutButtonAction: (() -> Void)?
    var searchWorkoutButtonAction: (() -> Void)?
    
    lazy var programNameLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Program Name", size: 21, weight: .bold)
    lazy var programNameTF: UITextField = CommonUI.uiTextFieldWillReturned(placeholder: "ex. Push Day")
    lazy var addWorkoutButton: UIButton = CommonUI.uiButtonWillReturned(title: "Add Workout", target: self, action: #selector(addWorkoutButtonDidTapped))
    lazy var searchWorkoutButton: UIButton = CommonUI.uiButtonWillReturned(title: "Search Workout", target: self, action: #selector(searchWorkoutButtonDidTapped))
    lazy var tableView: UITableView = UITableView()
    lazy var buttonsSTV: UIStackView = CommonUI.uiStackViewWillReturned(views: [addWorkoutButton, searchWorkoutButton], alignment: .fill, spacing: 25)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupHierarchy() {
        [programNameLabel, programNameTF, buttonsSTV, tableView].forEach { addSubview($0) }
    }
    
    override func setupConstraints() {
        programNameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(20)
        }
        programNameTF.snp.makeConstraints { make in
            make.top.equalTo(programNameLabel.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        buttonsSTV.snp.makeConstraints { make in
            make.top.equalTo(programNameTF.snp.bottom).offset(25)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(buttonsSTV.snp.bottom).offset(20)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    override func setupUI() {
        tableView.rowHeight = 70
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
