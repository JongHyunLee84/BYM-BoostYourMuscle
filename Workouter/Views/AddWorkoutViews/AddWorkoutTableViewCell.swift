//
//  AddWorkoutTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

final class AddWorkoutTableViewCell: BaseTableViewCell, PassingDataProtocol {
    typealias T = (SetVolume, Int)
    
    lazy var numberLabel: UILabel = UIFactory.uiLabelWillReturned(title: "1")
    lazy var weightLabel: UILabel = UIFactory.uiLabelWillReturned(title: "60 kg")
    lazy var repsLabel: UILabel = UIFactory.uiLabelWillReturned(title: "10 reps")
    lazy var stackView: UIStackView = UIFactory.uiStackViewWillReturned(views: [numberLabel,weightLabel,repsLabel], distribution: .equalSpacing )
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHierarchy() {
        addSubview(stackView)
    }
    
    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(25)
        }
    }
    
    func passData(_ data: (SetVolume, Int)) {
        let (volume, index) = data
        numberLabel.text = "\(index + 1) set"
        weightLabel.text = "\(volume.weight.toString) kg"
        repsLabel.text = "\(volume.reps) reps"
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
