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
    func doneButtonTapped()
}

class WorkoutRowCell: UITableViewCell {

    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var repsTF: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    // 체크 버튼 토글을 위한 델리게이트
    weak var delegate: WorkoutRowCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        setupTF()
    }

    @IBAction func checkButtonTapped(_ sender: Any) {
        delegate?.checkButtonTapped(cell: self)
    }
    
}

// MARK: - cell안에 TF 관련 Delegate

extension WorkoutRowCell: UITextFieldDelegate {
    
    func setupTF() {
        repsTF.delegate = self
        weightTF.delegate = self
        repsTF.keyboardType = .decimalPad
        weightTF.keyboardType = .decimalPad
        setupDoneButtonItem()
    }
    
    // 키보드 위에 Done 버튼 만들기
    func setupDoneButtonItem() {
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneButtonTapped))
        
        toolbar.setItems([flexSpace, doneButton], animated: true)
        toolbar.sizeToFit()
        
        repsTF.inputAccessoryView = toolbar
        weightTF.inputAccessoryView = toolbar
    }
    
    @objc func doneButtonTapped() {
        delegate?.doneButtonTapped()
    }
    
    // 텍스트필드 수정 시작 시 모든 텍스트가 선택되어 한번에 지울 수 있게
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        delegate?.textFieldDidEndEditing(cell: self, tag: textField.tag, value: textField.text ?? "0")
    }
}
