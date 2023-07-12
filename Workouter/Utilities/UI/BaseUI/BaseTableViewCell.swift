//
//  BaseTableViewCell.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/25.
//

import UIKit

class BaseTableViewCell: UITableViewCell, BaseViewItemProtocol {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {}
    
    func setupConstraints() {}
    
    func setupUI() {}
    
}
