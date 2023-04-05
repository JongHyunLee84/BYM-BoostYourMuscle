//
//  AddWorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

class AddWorkoutViewController: UIViewController {
    
    // MARK: - exercise와 workout이 같은 개념임
    private var exerciseVM = ExerciseViewModel()
    // 이전 뷰에 데이터 passing
    var dataClosure: ((ExerciseViewModel) -> Void)? = { exerciseVM in }
    
    @IBOutlet weak var targetPickerView: UIPickerView!
    @IBOutlet weak var workoutNameTF: UITextField!
    @IBOutlet weak var restTimeTF: UITextField!
    @IBOutlet weak var setsWeightTF: UITextField!
    @IBOutlet weak var setsRespsTF: UITextField!
    
    // 버튼 corner radius
    @IBOutlet weak var addWorkoutButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var addSetButton: UIButton!
    private lazy var buttons: [UIButton] = [addWorkoutButton, minusButton, plusButton, addSetButton]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        setupTableView()
        setupPickerView()
        setupForKeyBoard()
        setupTFDelegate()
    }
    // MARK: - (-10,+10) 구분해서 TF에 추가시키기
    @IBAction func restTimeButtonTapped(_ sender: UIButton) {
        restTimeTF.text = exerciseVM.changeRestTime(sender.tag)
    }
    // MARK: - 테이블 뷰에 해당 리스트 추가시켜야함
    @IBAction func setsAddButtonTapped(_ sender: Any) {
        guard setsWeightTF.text != "" && setsRespsTF.text != "" else { print("no data in TF"); return }
        exerciseVM.addPSet(weight: setsWeightTF.text, reps: setsRespsTF.text)
        // MARK: - 바인딩을 하는게 맞나?
        tableView.reloadData()
    }
    // MARK: - 해당 뷰 내리면서 workout 데이터 이전 뷰에 저장시키고 테이블 뷰에 보여줘야함 (데이터 추가 안된거 있으면 저장 x)
    @IBAction func addWorkoutTapeed(_ sender: Any) {
        if exerciseVM.numberOfSets() == 0 || restTimeTF.text == "" || workoutNameTF.text == "" {
            // 입력되지 않은 뷰가 있다면 alert
            var message = ""
            if workoutNameTF.text == "" {
                message = "Please enter name of this workout"
            }else if restTimeTF.text == "" {
                message = "Please enter rest time"
            } else {
                message = "Please add at least one set to your workout."
                
            }
            let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        } else {
            guard let dataClosure else { print("no dataClosure"); return }
            dataClosure(exerciseVM)
            dismiss(animated: true)
            
            
        }
        
    }
    
    
}

extension AddWorkoutViewController {
    func setupButtons() {
        buttons.forEach { button in
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
        }
    }
    
    // 뷰 아무 곳 터치시 키보드 내리기
        func setupForKeyBoard() {
            let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            tap.cancelsTouchesInView = false
            view.addGestureRecognizer(tap)
        }
}

// MARK: - PickerView Extension

extension AddWorkoutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func setupPickerView() {
        targetPickerView.delegate = self
        targetPickerView.dataSource = self
    }
    
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
        exerciseVM.saveTarget(row)
    }
    
    // pickerView에서 보여주고 싶은 아이템의 제목
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Target.allCases[row].rawValue
    }
    
}

// MARK: - TableView 관련 Extension

extension AddWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exerciseVM.numberOfSets()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addWorkoutTableViewCell, for: indexPath) as! AddWorkoutTableViewCell
        let row = indexPath.row
        cell.setupUI(exerciseVM.returnPsetAt(row), index: row)
        return cell
    }
    
    // MARK: - 테이블 삭제

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            exerciseVM.removePsetAt(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}

extension AddWorkoutViewController: UITextFieldDelegate {
    func setupTFDelegate() {
        restTimeTF.delegate = self
        setsWeightTF.delegate = self
        setsRespsTF.delegate = self
        workoutNameTF.delegate = self
    }
    
    // 텍스트필드 수정 시작 시 모든 텍스트가 선택되어 한번에 지울 수 있게
        func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.selectAll(nil)
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            exerciseVM.saveName(workoutNameTF.text ?? "")
        } else if textField.tag == 2 {
            exerciseVM.saveRest(restTimeTF.text ?? "0")
        }
    }
    
}
