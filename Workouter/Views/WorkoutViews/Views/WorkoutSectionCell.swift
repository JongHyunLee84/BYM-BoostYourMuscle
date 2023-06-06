//
//  WorkoutSectionCell.swift
//  BYM
//
//  Created by 이종현 on 2023/03/31.
//

import UIKit

class WorkoutSectionCell: UITableViewCell {

    let workoutNameLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Label", size: 17)
    let triangleImageView: UIImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.right.fill"))
    lazy var stackView: UIStackView = CommonUI.uiStackViewWillReturned(views: [workoutNameLabel, triangleImageView], alignment: .fill, spacing: 17, distribution: .fill)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 전환에 따른 애니메이션
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        // ui
        triangleImageView.tintColor = .black
        
        // constraints
        contentView.addSubview(stackView)
        workoutNameLabel.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(250)
        }
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.center.equalToSuperview()
        }
        
    }
    
}

import SwiftUI

#if canImport(SwiftUI) && DEBUG
struct WorkoutSectionCellViewCellPreview<View: UIView>: UIViewRepresentable {
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
struct WorkoutSectionCellPreview_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = WorkoutSectionCell()
            return vc
        }
    }
}
