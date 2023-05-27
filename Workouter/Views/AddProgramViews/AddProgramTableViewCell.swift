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
    
    private func uiLabelWillReturned(_ title: String) -> UILabel {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 17)
        lb.text = title
        lb.textAlignment = .center
        lb.textColor = .black
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
