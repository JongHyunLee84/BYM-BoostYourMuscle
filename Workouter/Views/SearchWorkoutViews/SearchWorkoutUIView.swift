//
//  SearchWorkoutUIView.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/05.
//

import UIKit

final class SearchWorkoutUIView: BaseUIView {
    
    var buttonTappedAction: ((UIButton)->Void)?
    
    lazy var scrollView: UIScrollView = UIScrollView()
    lazy var tableView: UITableView = UITableView()
    lazy var allButton: UIButton = UIFactory.uiButtonWillReturned(title: "All", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var chestButton: UIButton = UIFactory.uiButtonWillReturned(title: "Chest", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var backButton: UIButton = UIFactory.uiButtonWillReturned(title: "Back", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var lowerLegsButton: UIButton = UIFactory.uiButtonWillReturned(title: "Lower Legs", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var shouldersButton: UIButton = UIFactory.uiButtonWillReturned(title: "Shoulders", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var upperArmsButton: UIButton = UIFactory.uiButtonWillReturned(title: "Upper Arms", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var upperLegButton: UIButton = UIFactory.uiButtonWillReturned(title: "Upper Legs", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))
    lazy var lowerArmsButton: UIButton = UIFactory.uiButtonWillReturned(title: "Lower Arms", fontSize: 13, target: self, action: #selector(targetButtonTapped(_:)))

    lazy var buttonsSTV: UIStackView = UIFactory.uiStackViewWillReturned(views: buttons, alignment: .fill, spacing: 15)
    lazy var buttons: [UIButton] = [allButton, chestButton, backButton, lowerLegsButton, shouldersButton, upperArmsButton, upperLegButton, lowerArmsButton]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHierarchy() {
        scrollView.addSubview(buttonsSTV)
        [scrollView, tableView].forEach { addSubview($0) }
    }
    
    override func setupConstraints() {
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
    
    override func setupUI() {
        tableView.allowsSelection = false
        tableView.rowHeight = 100
        scrollView.showsHorizontalScrollIndicator = false
        allButton.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
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
