//
//  AddWorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

final class AddWorkoutViewController: BaseViewController, KeyboardProtocol {
    
    // MARK: - exercise와 workout이 같은 개념임, 이전 뷰에서 exercise 데이터 받아옴.
    var viewModel = ExerciseViewModel()
    // 이전 뷰에 데이터 passing
    var addButtonTapped: ((Exercise) -> Void) = { _ in }
    var viewDisappear: ((Exercise) -> Void) = { _ in }
    var addedWorkout: ((ExerciseViewModel) -> Void) = { _ in }
    
    private lazy var customView = AddWorkoutUIView()
    
    override func loadView() {
        view = customView
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewDisappear(viewModel.exercise)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // pickerview data는 viewDidLoad 이후에 로드된다. 즉, viewDidLoad에서 피커뷰 데이터 관련 코드 넣어도 안 먹는다.
        passDataToUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func setupUI() {
        customView.tableView.register(AddWorkoutTableViewCell.self, forCellReuseIdentifier: Identifier.addWorkoutTableViewCell)
        setupKeyborad(self.view)
    }
    
    override func setupDelegate() {
        customView.workoutNameTF.delegate = self
        customView.targetPickerView.delegate = self
        customView.targetPickerView.dataSource = self
        customView.restTimeTF.delegate = self
        customView.setsWeightTF.delegate = self
        customView.setsRepsTF.delegate = self
        customView.tableView.dataSource = self
        customView.tableView.delegate = self
    }
    
    override func setupRxBind() {
        customView.addWorkoutAction = addWorkoutTapped
        customView.minusButtonAction = minusAndPlusButtonTapped(_:)
        customView.plusButtonAction = minusAndPlusButtonTapped(_:)
        customView.setsAddButtonAction = setsAddButtonTapped
    }
    
    // MARK: - 해당 뷰 내리면서 workout 데이터 이전 뷰에 저장시키고 테이블 뷰에 보여줘야함 (데이터 추가 안된거 있으면 저장 x)
    private func addWorkoutTapped() {
        if viewModel.numberOfSets.isZero || customView.restTimeTF.text == "" || customView.workoutNameTF.text == "" {
            // 입력되지 않은 뷰가 있다면 alert
            var message = ""
            if customView.workoutNameTF.text == "" {
                message = "Please enter name of this workout"
            }else if customView.restTimeTF.text == "" {
                message = "Please enter rest time"
            } else {
                message = "Please add at least one set to your workout."
                
            }
            let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        } else {
            addButtonTapped(viewModel.exercise) // addProgramView에게 보냄
            addedWorkout(viewModel) // searchWorkoutView에게 보냄
            viewModel = ExerciseViewModel() // add가 눌려서 뷰가 사라질 때는 빈 VM을 이전뷰로 보내기 위해
            dismiss(animated: true)
        }
    }
    
    // MARK: - (-10,+10) 구분해서 TF에 추가시키기
    private func minusAndPlusButtonTapped(_ tag : Int) {
        customView.restTimeTF.text = viewModel.changeRestTime(tag)
    }
    
    // MARK: - 테이블 뷰에 해당 리스트 추가시켜야함
    private func setsAddButtonTapped() {
        guard customView.setsWeightTF.text != "" && customView.setsRepsTF.text != "" else { print("no data in TF"); return }
        viewModel.addPSet(weight: customView.setsWeightTF.text, reps: customView.setsRepsTF.text)
        // MARK: - 바인딩을 하는게 맞나?
        customView.tableView.reloadData()
    }
    
    
}

// MARK: - UI

extension AddWorkoutViewController {
    private func passDataToUI() {
        customView.workoutNameTF.text = viewModel.name.capitalized
        customView.targetPickerView.selectRow(Target.allCases.firstIndex(of: viewModel.target)!, inComponent: 0, animated: true)
        customView.restTimeTF.text = "\(viewModel.returnRest())"
        customView.setsWeightTF.text = String(Int(viewModel.sets.last?.weight ?? 60))
        customView.setsRepsTF.text = String(viewModel.sets.last?.reps ?? 10)
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
        viewModel.saveTarget(row)
    }
    
    // pickerView에서 보여주고 싶은 아이템의 제목
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Target.allCases[row].rawValue
    }
    
    
}

// MARK: - TableView 관련 Extension

extension AddWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.numberOfSets.isZero {
            tableView.setEmptyMessage("How many sets are you going to do? 🤔")
        } else {
            tableView.restore()
        }
        return viewModel.numberOfSets
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addWorkoutTableViewCell, for: indexPath) as! AddWorkoutTableViewCell
        let row = indexPath.row
        cell.passData(viewModel.returnPsetAt(row))
        return cell
    }
    
    // MARK: - 테이블 삭제
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            viewModel.removePsetAt(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}

// MARK: - TextField Extension

extension AddWorkoutViewController: UITextFieldDelegate {
    
    // 텍스트필드 수정 시작 시 모든 텍스트가 선택되어 한번에 지울 수 있게
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            viewModel.saveName(customView.workoutNameTF.text ?? "")
        } else if textField.tag == 2 {
            viewModel.saveRest(customView.restTimeTF.text ?? "0")
        }
    }
    
}
