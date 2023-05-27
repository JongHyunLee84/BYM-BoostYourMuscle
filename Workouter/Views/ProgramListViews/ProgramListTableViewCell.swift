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
    
    private lazy var programTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        lb.textColor = .black
        lb.text = "Label"
        return lb
    }()
    
    private lazy var editButton: UIButton = {
        let bt = UIButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 25,
                                                      weight: .bold,
                                                      scale: .medium)
        
        let ellipsis = UIImage(systemName: "ellipsis", withConfiguration: largeConfig)
        bt.setImage(ellipsis, for: .normal)
        bt.imageView?.tintColor = .black

        return bt
    }()
    
    private lazy var stackView: UIStackView = {
        let stv = UIStackView(arrangedSubviews: [programTitleLabel, editButton])
        stv.axis = .horizontal
        stv.distribution = .equalSpacing
        addSubview(stv)
        return stv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(35)
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
        
        print("will return menu")
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
