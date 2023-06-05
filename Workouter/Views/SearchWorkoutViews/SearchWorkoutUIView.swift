//
//  SearchWorkoutUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/05.
//

import UIKit

class SearchWorkoutUIView: UIView {
    
    let scrollView: UIScrollView = UIScrollView()
    let tableView: UITableView = UITableView()
    let chestButton: UIButton = CommonUI.uiButtonWillReturned(title: "Chest", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    let lowerLegsButton: UIButton = CommonUI.uiButtonWillReturned(title: "Lower Legs", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    let shouldersButton: UIButton = CommonUI.uiButtonWillReturned(title: "Shoulders", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    let upperArmsButton: UIButton = CommonUI.uiButtonWillReturned(title: "Upper Arms", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    let upperLegButton: UIButton = CommonUI.uiButtonWillReturned(title: "Upper Legs", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    let lowerArmsButton: UIButton = CommonUI.uiButtonWillReturned(title: "Lower Arms", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    let backButton: UIButton = CommonUI.uiButtonWillReturned(title: "Back", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    private lazy var buttons: [UIButton] = [chestButton, lowerLegsButton, shouldersButton, upperArmsButton, upperLegButton, lowerArmsButton, backButton]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        KeyboardManager.setupKeyborad(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        
    }
    
    @objc func targetButtonTapped(_ sender: UIButton) {
        
    }
    
}
