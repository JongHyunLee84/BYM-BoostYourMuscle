//
//  AddedWorkoutTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

class AddProgramTableViewCell: UITableViewCell {
    
    var exerciseVM: ExerciseViewModel? {
        didSet {
            passDataToUI()
        }
    }
    
    let workoutNameLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Name", alignment: .center)
    let targetLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Target", alignment: .center)
    let setsLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Sets", alignment: .center)
    lazy var stackView: UIStackView = CommonUI.uiStackViewWillReturned(views: [workoutNameLabel,targetLabel,setsLabel])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func passDataToUI() {
        guard let exerciseVM else { return }
        workoutNameLabel.text = exerciseVM.returnName()
        targetLabel.text = exerciseVM.returnTarget()
        setsLabel.text = exerciseVM.returnSets()
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
}

import SwiftUI

#if canImport(SwiftUI) && DEBUG

struct AddProgramTableViewCellPreview<View: UIView>: UIViewRepresentable {
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
struct AddProgramTableViewCellPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = AddProgramTableViewCell()
            return vc
        }
    }
}
