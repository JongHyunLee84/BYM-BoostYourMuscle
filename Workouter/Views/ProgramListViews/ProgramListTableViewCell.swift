//
//  ProgramListTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit
import SnapKit
// edit 버튼이 눌렸을 때 프로그램 편집 뷰로 넘어가야함.
protocol ProgramListViewDelegate: AnyObject {
    func deleteProgram(_ cell: UITableViewCell?)
}

final class ProgramListTableViewCell: UITableViewCell {
    
    weak var delegate: ProgramListViewDelegate?
    
    let programTitleLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Label", size: 25, weight: .medium)
    let editButton: UIButton = CommonUI.uiImageButtonWillReturned("ellipsis", size: 25, weight: .medium, scale: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        
        [programTitleLabel, editButton].forEach { contentView.addSubview($0) }
        
        programTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func setupCell(_ vm: ProgramViewModel) {
        programTitleLabel.text = vm.title
        editButton.showsMenuAsPrimaryAction = true
        editButton.menu = returnMenu()
    }
    
    func returnMenu() -> UIMenu {
        let usersItem = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { [weak self] _ in
            self?.delegate?.deleteProgram(self)
        }
        return UIMenu(title: "Menu", options: .displayInline, children: [usersItem])
    }

    
}

import SwiftUI

#if canImport(SwiftUI) && DEBUG
struct ProgramListTableViewCellPreview<View: UIView>: UIViewRepresentable {
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
struct ProgramListTableViewCellPreview_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = ProgramListTableViewCell()
            return vc
        }
    }
}
