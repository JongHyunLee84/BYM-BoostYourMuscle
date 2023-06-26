//
//  BaseUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/25.
//

import UIKit

class BaseUIView: UIView, BaseViewItemProtocol {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .white
        setupHierarchy()
        setupConstraints()
        setupUI()
    }
    
    func setupHierarchy() {}
    func setupConstraints() {}
    func setupUI() {}
    
}
