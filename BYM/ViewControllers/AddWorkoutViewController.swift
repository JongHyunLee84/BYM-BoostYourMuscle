//
//  AddWorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

class AddWorkoutViewController: UIViewController {

    @IBOutlet weak var targetPickerView: UIPickerView! {
        didSet {
            targetPickerView.delegate = self
            targetPickerView.dataSource = self
        }
    }
    
    @IBOutlet weak var workoutNameTF: UITextField!
    @IBOutlet weak var restTimeTF: UITextField!
    @IBOutlet weak var setsWeightTF: UITextField!
    @IBOutlet weak var setsRespsTF: UITextField!
    
    // 버튼 corner radius
    @IBOutlet weak var addWorkoutButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addSetButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    
    private var target: Target? {
        didSet {
            // MARK: - target 정해지면 수행할 동작
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()

    }
    // MARK: - (-10,+10) 구분해서 TF에 추가시키기
    @IBAction func restTimeButtonTapped(_ sender: UIButton) {
    }
    // MARK: - 테이블 뷰에 해당 리스트 추가시켜야함
    @IBAction func setsAddButtonTapped(_ sender: Any) {
    }
    // MARK: - 해당 뷰 내리면서 workout 데이터 이전 뷰에 저장시키고 테이블 뷰에 보여줘야함 (데이터 추가 안된거 있으면 저장 x)
    @IBAction func addWorkoutTapeed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    
}

extension AddWorkoutViewController {
    func setupButtons() {
        addWorkoutButton.layer.cornerRadius = 14
        addWorkoutButton.layer.masksToBounds = true
        minusButton.layer.cornerRadius = 8
        minusButton.layer.masksToBounds = true
        plusButton.layer.cornerRadius = 8
        plusButton.layer.masksToBounds = true
        addSetButton.layer.cornerRadius = 8
        addSetButton.layer.masksToBounds = true
    }
}

// MARK: - PickerView Extension

extension AddWorkoutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // pickerView에 담긴 아이템의 컴포넌트 갯수 (= 휠의 갯수)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // pickerView에 표현하고 싶은 아이템의 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Target.allCases.count
    }
    // pickerView에서 특정 아이템을 선택했을 때의 행위
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        target = Target.allCases[row]
    }
    
    // pickerView에서 보여주고 싶은 아이템의 제목
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Target.allCases[row].rawValue
    }
    
}

extension AddWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddSetTableViewCell", for: indexPath) as! AddSetTableViewCell
        cell.numberLabel.text = "1"
        cell.weightLabel.text = "60kg"
        cell.respsLabel.text = "10reps"
        return cell
    }
    
    
}

