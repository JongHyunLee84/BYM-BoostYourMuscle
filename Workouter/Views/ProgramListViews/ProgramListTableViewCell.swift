//
//  ProgramListTableViewCell.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import SnapKit
import UIKit

final class ProgramListTableViewCell: BaseTableViewCell, PassingDataProtocol {
    
    typealias T = Program
    
    var deleteProgram: () -> Void = {}
    
    lazy var programTitleLabel: UILabel = CommonUI.uiLabelWillReturned(title: "Label", size: 25, weight: .medium)
    lazy var editButton: UIButton = CommonUI.uiImageButtonWillReturned("ellipsis", size: 25, weight: .medium, scale: .medium)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHierarchy() {
        [programTitleLabel, editButton].forEach { contentView.addSubview($0) }
    }
    
    override func setupConstraints() {
        programTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        editButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    override func setupUI() {
        self.selectionStyle = .none
        editButton.showsMenuAsPrimaryAction = true
        editButton.menu = returnMenu()
    }
    
    func passData(_ vm: Program) {
        programTitleLabel.text = vm.title
    }
    
    func returnMenu() -> UIMenu {
        let usersItem = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { [weak self] _ in
            self?.deleteProgram()
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
