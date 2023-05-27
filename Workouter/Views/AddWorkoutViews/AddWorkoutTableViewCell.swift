//
//  AddWorkoutTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

class AddWorkoutTableViewCell: UITableViewCell {

    private func uiLabelWillReturned(title t: String) -> UILabel {
        let lb = UILabel()
        lb.text = t
        lb.textAlignment = .center
        lb.font = .systemFont(ofSize: 17, weight: .medium)
        return lb
    }
    
    private lazy var numberLabel: UILabel = uiLabelWillReturned(title: "1")
    private lazy var weightLabel: UILabel = uiLabelWillReturned(title: "60 kg")
    private lazy var repsLabel: UILabel = uiLabelWillReturned(title: "10 reps")
    private lazy var stackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [numberLabel,weightLabel,repsLabel])
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
    
    func passDataToUI(_ vm: PSetViewModel, index: Int) {
        numberLabel.text = "\(index + 1) set"
        weightLabel.text = vm.returnWeight()
        repsLabel.text = vm.returnReps()
    }
    
    private func setupConstraints() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(25)
        }
    }

}

import SwiftUI

#if canImport(SwiftUI) && DEBUG

struct AddWorkoutCellPreview<View: UIView>: UIViewRepresentable {
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
struct AddWorkoutCellPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = AddWorkoutTableViewCell()
            return vc
        }
    }
}
