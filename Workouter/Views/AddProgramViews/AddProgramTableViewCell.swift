//
//  AddedWorkoutTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import SnapKit
import UIKit

final class AddProgramTableViewCell: BaseTableViewCell, PassingDataProtocol {
    
    typealias T = Workout
    
    let workoutNameLabel: UILabel = UIFactory.uiLabelWillReturned(title: "Name", alignment: .center)
    let targetLabel: UILabel = UIFactory.uiLabelWillReturned(title: "Target", alignment: .center)
    let setsLabel: UILabel = UIFactory.uiLabelWillReturned(title: "Sets", alignment: .center)
    lazy var stackView: UIStackView = UIFactory.uiStackViewWillReturned(views: [workoutNameLabel,targetLabel,setsLabel])
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
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
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
    
    override func setupUI() {
        workoutNameLabel.adjustsFontSizeToFitWidth = true
        workoutNameLabel.numberOfLines = 0
    }
    
    func passData(_ data: Workout) {
        workoutNameLabel.text = data.name
        targetLabel.text = data.target.rawValue
        setsLabel.text = "\(data.sets.count)"
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
