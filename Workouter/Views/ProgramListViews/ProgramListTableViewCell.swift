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
        lb.font = UIFont.systemFont(ofSize: 25)
        return lb
    }()
    
    private lazy var editButton: UIButton = {
        let bt = UIButton()
        bt.setImage(UIImage(named: "ellipsis"), for: .application)
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
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
    
    func setupCell(_ vm: ProgramViewModel) {
        programTitleLabel.text = vm.title
        editButton.menu = returnMenu()
        editButton.showsMenuAsPrimaryAction = true
    }
    
    func returnMenu() -> UIMenu {
        let usersItem = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { [weak self] _ in
            self?.delegate?.deleteProgram(self)
         }

        return UIMenu(title: "Menu", options: .displayInline, children: [usersItem])
    }
    
}

