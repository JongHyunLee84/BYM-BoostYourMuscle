//
//  WorkoutRowCell.swift
//  BYM
//
//  Created by 이종현 on 2023/03/31.
//

import UIKit

protocol WorkoutRowCellDelegate: AnyObject {
    func checkButtonTapped(cell: WorkoutRowCell)
    func textFieldDidEndEditing(cell: WorkoutRowCell, tag: Int, value: String)
    func keyboardDoneButtonTapped()
}

final class WorkoutRowCell: BaseTableViewCell {
    
    lazy var setLabel: UILabel = UIFactory.uiLabelWillReturned(title: "1", size: 17)
    lazy var weightLabel: UILabel = UIFactory.uiLabelWillReturned(title: "weight", size: 17)
    lazy var weightTF: UITextField = UIFactory.uiTextFieldWillReturned()
    lazy var repsLabel: UILabel = UIFactory.uiLabelWillReturned(title: "reps", size: 17)
    lazy var repsTF: UITextField = UIFactory.uiTextFieldWillReturned(tag: 1)
    lazy var checkButton: UIButton = UIFactory.uiImageButtonWillReturned("square", target: self, action: #selector(checkButtonTapped))
    lazy var weightSTV: UIStackView = UIFactory.uiStackViewWillReturned(views: [weightLabel,weightTF], alignment: .fill, spacing: 5, distribution: .fillEqually)
    lazy var repsSTV: UIStackView = UIFactory.uiStackViewWillReturned(views: [repsLabel, repsTF], alignment: .fill, spacing: 5, distribution: .fillEqually)
    lazy var stackView: UIStackView = UIFactory.uiStackViewWillReturned(views: [setLabel, weightSTV, repsSTV, checkButton], alignment: .fill, spacing: 0, distribution: .equalSpacing)
    
    // 체크 버튼 토글을 위한 델리게이트
    weak var delegate: WorkoutRowCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupHierarchy() {
        contentView.addSubview(stackView)
    }
    override func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
        }
    }
    override func setupUI() {
        self.selectionStyle = .none
        repsTF.keyboardType = .decimalPad
        weightTF.keyboardType = .decimalPad
        setupDoneButtonItem()
        repsTF.delegate = self
        weightTF.delegate = self
    }
    
    @objc func checkButtonTapped() {
        delegate?.checkButtonTapped(cell: self)
    }
    
}

// MARK: - cell안에 TF 관련 Delegate

extension WorkoutRowCell: UITextFieldDelegate {
    
    // 키보드 위에 Done 버튼 만들기
    func setupDoneButtonItem() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(keyboardDoneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        repsTF.inputAccessoryView = toolbar
        weightTF.inputAccessoryView = toolbar
    }
    
    @objc func keyboardDoneButtonTapped() {
        delegate?.keyboardDoneButtonTapped()
    }
    
    // 텍스트필드 수정 시작 시 모든 텍스트가 선택되어 한번에 지울 수 있게
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.textFieldDidEndEditing(cell: self, tag: textField.tag, value: textField.text ?? "0")
    }
}

import SwiftUI

#if canImport(SwiftUI) && DEBUG
struct WorkoutRowCellViewCellPreview<View: UIView>: UIViewRepresentable {
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
struct WorkoutRowCellPreview_Previews: PreviewProvider {
    static var previews: some View {
        UIViewPreview {
            // Return whatever controller you want to preview
            let vc = WorkoutRowCell()
            return vc
        }
    }
}
