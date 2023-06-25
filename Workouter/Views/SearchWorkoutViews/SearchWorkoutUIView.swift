//
//  SearchWorkoutUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/05.
//

import UIKit

class SearchWorkoutUIView: UIView {
    
    var buttonTappedAction: ((UIButton)->Void)?
    
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var tableView: UITableView = UITableView()
    lazy var chestButton: UIButton = CommonUI.uiButtonWillReturned(title: "Chest", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var lowerLegsButton: UIButton = CommonUI.uiButtonWillReturned(title: "Lower Legs", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var shouldersButton: UIButton = CommonUI.uiButtonWillReturned(title: "Shoulders", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var upperArmsButton: UIButton = CommonUI.uiButtonWillReturned(title: "Upper Arms", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var upperLegButton: UIButton = CommonUI.uiButtonWillReturned(title: "Upper Legs", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var lowerArmsButton: UIButton = CommonUI.uiButtonWillReturned(title: "Lower Arms", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var backButton: UIButton = CommonUI.uiButtonWillReturned(title: "Back", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var buttonsSTV: UIStackView = CommonUI.uiStackViewWillReturned(views: buttons, alignment: .fill, spacing: 15)
    lazy var buttons: [UIButton] = [chestButton, lowerLegsButton, shouldersButton, upperArmsButton, upperLegButton, lowerArmsButton, backButton]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        scrollView.addSubview(buttonsSTV)
        [scrollView, tableView].forEach { addSubview($0) }
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(5)
            make.trailing.equalToSuperview()
            make.height.equalTo(50)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
        }
        buttonsSTV.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(5)
            make.leading.equalTo(scrollView.snp.leading)
            make.trailing.equalTo(scrollView.snp.trailing)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        tableView.allowsSelection = false
        tableView.rowHeight = 100
        scrollView.showsHorizontalScrollIndicator = false
        chestButton.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        buttons.forEach { button in
            button.frame = CGRect(x: 160, y: 100, width: 30, height: 30)
            button.layer.cornerRadius = 0.5 * button.bounds.size.width
            button.clipsToBounds = true
            // 버튼 테두리
            button.layer.borderWidth = 2.0
            button.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
    }
    
    @objc func targetButtonTapped(_ sender: UIButton) {
        buttonTappedAction?(sender)
    }
    
}

import SwiftUI

#if canImport(SwiftUI) && DEBUG
struct SearchWorkoutUIViewPreview<View: UIView>: UIViewRepresentable {
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
struct SearchWorkoutUIViewPreviews_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = SearchWorkoutUIView()
            return vc
        }
    }
}
