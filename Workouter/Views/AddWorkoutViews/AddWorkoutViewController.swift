//
//  AddWorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import RxCocoa
import RxSwift
import UIKit

final class AddWorkoutViewController: BaseViewController, KeyboardProtocol, Alertable {
    
    // MARK: - exercise와 workout이 같은 개념임, 이전 뷰에서 exercise 데이터 받아옴.
    var viewModel: AddWorkoutViewModel
    // 이전 뷰에 데이터 passing
    var addButtonTapped: ((Workout) -> Void) = { _ in }
    var viewDisappear: ((Workout) -> Void) = { _ in }
    
    private lazy var customView = AddWorkoutUIView()
    
    
    // MARK: - Life cyle
    init(exercise: Workout = Workout()) {
        viewModel = AddWorkoutViewModel(exercise: exercise)
        super.init() // VC의 custom init을 위해서 -> BaseVC Protocol에 코드 있음.
        
        // 초기 값 세팅
        customView.workoutNameTF.text = exercise.name
        customView.restTimeTF.text = exercise.rest.toString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // MARK: - 최초 한번만 이전 뷰에서 넘어온 workout data가 있다면 뷰에 바인딩 (피커뷰라서 viewWillAppear에)
        viewModel.exerciseRelay
            .take(1)
            .bind {
                self.customView.targetPickerView.selectRow(Target[$0.target], inComponent: 0, animated: false)
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewDisappear(viewModel.exerciseRelay.value)
    }
    
    override func setupUI() {
        customView.tableView.register(AddWorkoutTableViewCell.self, forCellReuseIdentifier: Identifier.addWorkoutTableViewCell)
        setupKeyborad(self.view)
    }
    
    override func setupRxBind() {
        let view = customView
        
        view.addWorkoutButton.rx.tap
            .map { [weak self] () -> (Bool, Workout) in
                guard let self = self else { return (false, Workout()) }
                return (self.viewModel.isExerciseSavable.value, self.viewModel.exerciseRelay.value)
            }
            .bind { (isTrue, exercise) in
                if isTrue {
                    self.addButtonTapped(self.viewModel.exerciseRelay.value) // 추가된다면 이전 뷰가 리스트로 갖고 있음.
                    self.viewModel.exerciseRelay.accept(Workout()) // Add 되었으니 다시 이전 뷰에서 present할 때는 아무것도 안 채운 exercise를 보내야함.
                    self.dismiss(animated: true)
                } else {
                    self.showAlert(title: self.viewModel.alertTitle, message: self.viewModel.addExerciseMessage, actions: nil)
                }
            }
            .disposed(by: disposeBag)
        
        view.minusButton.rx.tap
            .bind { self.viewModel.changeRestTime(0) }
            .disposed(by: disposeBag)
        
        view.plusButton.rx.tap
            .bind { self.viewModel.changeRestTime(1) }
            .disposed(by: disposeBag)
        
        view.addSetButton.rx.tap
            .map { [weak self] () -> Bool in
                guard let self = self else { return false }
                return self.viewModel.isSetSavable.value
            }
            .bind { isSavable in
                isSavable ? self.viewModel.addSetVolume() : self.showAlert(title: self.viewModel.alertTitle, message: self.viewModel.addSetVolumeMessage, actions: nil)
            }
            .disposed(by: disposeBag)
            
        view.workoutNameTF.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .bind(to: viewModel.exerciseNameRelay)
            .disposed(by: disposeBag)
        
        view.restTimeTF.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .filter { Int($0) != nil }
            .map { Int($0)! }
            .bind(to: viewModel.restTimeRelay)
            .disposed(by: disposeBag)
        
        view.setsWeightTF.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .filter { Double($0) != nil }
            .map { Double($0)! }
            .bind(to: viewModel.setsWeightRelay)
            .disposed(by: disposeBag)
        
        view.setsRepsTF.rx.text
            .orEmpty
            .distinctUntilChanged()
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .filter { Int($0) != nil }
            .map { Int($0)! }
            .bind(to: viewModel.setsRepsRelay)
            .disposed(by: disposeBag)
        
        view.tableView.rx.itemDeleted
            .bind { indexPath in
                self.viewModel.removeSetVolumeAt(indexPath.row)
            }
            .disposed(by: disposeBag)
        
        view.textFieldList.forEach{ tf in
            tf.rx.controlEvent(.allTouchEvents)
                .bind {
                    tf.selectAll(nil)
                }
                .disposed(by: disposeBag)
        }

        // MARK: - Picker View
        Observable.just(Target.allCases.map { $0.rawValue })
            .bind(to: view.targetPickerView.rx.itemTitles) { (_, element) in
                return element
            }
            .disposed(by: disposeBag)
        
        view.targetPickerView.rx.itemSelected
            .bind { (row, value) in
                self.viewModel.targetRelay.accept(row)
            }
            .disposed(by: disposeBag)
        
        viewModel.restTimeRelay
            .distinctUntilChanged()
            .map { $0.toString }
            .bind(to: view.restTimeTF.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.setsRelay
            .bind(to: view.tableView.rx.items(cellIdentifier: Identifier.addWorkoutTableViewCell, cellType: AddWorkoutTableViewCell.self)) { row, item, cell in
                cell.passData((item, row))
            }
            .disposed(by: disposeBag)
        
        viewModel.numberOfSetsRelay
            .bind {
                $0.isZero ? self.customView.tableView.setEmptyMessage(self.viewModel.emptyMessage) : self.customView.tableView.restore()
            }
            .disposed(by: disposeBag)
        
    }
    
    

    
    
}

// MARK: - UI

extension AddWorkoutViewController {
    // TODO: searchview와 연결할 때 다시 수정?
//    private func passDataToUI() {
//        customView.workoutNameTF.text = viewModel.name.capitalized
//        customView.targetPickerView.selectRow(Target.allCases.firstIndex(of: viewModel.target)!, inComponent: 0, animated: true)
//        customView.restTimeTF.text = "\(viewModel.returnRest())"
//        customView.setsWeightTF.text = String(Int(viewModel.sets.last?.weight ?? 60))
//        customView.setsRepsTF.text = String(viewModel.sets.last?.reps ?? 10)
//    }
    
}





//// MARK: - 해당 뷰 내리면서 workout 데이터 이전 뷰에 저장시키고 테이블 뷰에 보여줘야함 (데이터 추가 안된거 있으면 저장 x)
//private func addWorkoutTapped() {
//    if viewModel.numberOfSets.isZero || customView.restTimeTF.text == "" || customView.workoutNameTF.text == "" {
//        // 입력되지 않은 뷰가 있다면 alert
//        var message = ""
//        if customView.workoutNameTF.text == "" {
//            message = "Please enter name of this workout"
//        }else if customView.restTimeTF.text == "" {
//            message = "Please enter rest time"
//        } else {
//            message = "Please add at least one set to your workout."
//
//        }
//        let alert = UIAlertController(title: "Missing Information", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//        self.present(alert, animated: true, completion: nil)
//    } else {
//        addButtonTapped(viewModel.exerciseRelay.value) // addProgramView에게 보냄
//        addedWorkout(viewModel) // searchWorkoutView에게 보냄
//        viewModel = ExerciseViewModel() // add가 눌려서 뷰가 사라질 때는 빈 VM을 이전뷰로 보내기 위해
//        dismiss(animated: true)
//    }
//}
//// MARK: - (-10,+10) 구분해서 TF에 추가시키기
//private func minusAndPlusButtonTapped(_ tag : Int) {
//    customView.restTimeTF.text = viewModel.changeRestTime(tag)
//}
//    // MARK: - 테이블 뷰에 해당 리스트 추가시켜야함
//    private func setsAddButtonTapped() {
//        guard customView.setsWeightTF.text != "" && customView.setsRepsTF.text != "" else { print("no data in TF"); return }
//        viewModel.addPSet(weight: customView.setsWeightTF.text, reps: customView.setsRepsTF.text)
//        // MARK: - 바인딩을 하는게 맞나?
//        customView.tableView.reloadData()
//    }
//extension AddWorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if viewModel.numberOfSets.isZero {
//            tableView.setEmptyMessage("How many sets are you going to do? 🤔")
//        } else {
//            tableView.restore()
//        }
//        return viewModel.numberOfSets
//    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addWorkoutTableViewCell, for: indexPath) as! AddWorkoutTableViewCell
//        let row = indexPath.row
//        cell.passData(viewModel.returnPsetAt(row))
//        return cell
//    }
//
//    // MARK: - 테이블 삭제
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
//        return .delete
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            tableView.beginUpdates()
//            viewModel.removePsetAt(indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//            tableView.endUpdates()
//        }
//    }
//
//}
//// MARK: - TableView 관련 Extension
//
//
//
//// MARK: - TextField Extension
//
//extension AddWorkoutViewController: UITextFieldDelegate {
//
//    // 텍스트필드 수정 시작 시 모든 텍스트가 선택되어 한번에 지울 수 있게
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        textField.selectAll(nil)
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if textField.tag == 1 {
//            viewModel.saveName(customView.workoutNameTF.text ?? "")
//        } else if textField.tag == 2 {
//            viewModel.saveRest(customView.restTimeTF.text ?? "0")
//        }
//    }
//
//}
//// MARK: - PickerView Extension
//
//extension AddWorkoutViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//
//
//    // pickerView에 담긴 아이템의 컴포넌트 갯수 (= 휠의 갯수)
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    // pickerView에 표현하고 싶은 아이템의 갯수
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return Target.allCases.count
//    }
//    // pickerView에서 특정 아이템을 선택했을 때의 행위
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        viewModel.saveTarget(row)
//    }
//
//    // pickerView에서 보여주고 싶은 아이템의 제목
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return Target.allCases[row].rawValue
//    }
//
//
//}
