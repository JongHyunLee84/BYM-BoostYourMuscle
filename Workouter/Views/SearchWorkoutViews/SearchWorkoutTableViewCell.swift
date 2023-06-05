//
//  SearchWorkoutTableViewCell.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/12.
//

import UIKit

class SearchWorkoutTableViewCell: UITableViewCell {

    let workoutImageView: UIImageView = CommonUI.uiImageViewWillReturned()
    let nameLabel: UILabel = CommonUI.uiLabelWillReturned(title: "name")
    let targetLabel: UILabel = CommonUI.uiLabelWillReturned(title: "target")
    let equipmentLabel: UILabel = CommonUI.uiLabelWillReturned(title: "equipment")
    let plusButton: UIButton = CommonUI.uiImageButtonWillReturned("plus", target: self, action: #selector(plusButtonTapped))
    lazy var labelsSTV: UIStackView = CommonUI.uiStackViewWillReturned(views: [nameLabel, targetLabel, equipmentLabel], alignment: .fill, axis: .vertical, spacing: 0)
    
    var plusButtonAction: (() -> Void) = {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            setupConstraints()
        }

    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    private func setupConstraints() {
        nameLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        [workoutImageView, labelsSTV, plusButton].forEach { addSubview($0) }
        
        [workoutImageView, labelsSTV].forEach { view in
            view.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().offset(10)
                make.width.equalToSuperview().multipliedBy(0.4)
            }
        }
        workoutImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(labelsSTV.snp.leading).inset(10)
        }
        
        plusButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
        }
    }

    @objc func plusButtonTapped() {
        plusButtonAction()
    }
    
}

import SwiftUI

#if canImport(SwiftUI) && DEBUG

struct SearchCellPreview<View: UIView>: UIViewRepresentable {
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
struct SearchCellPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = SearchWorkoutTableViewCell()
            return vc
        }
    }
}
