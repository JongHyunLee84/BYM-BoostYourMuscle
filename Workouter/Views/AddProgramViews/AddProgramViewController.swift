//
//  AddProgramViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

class AddProgramViewController: BaseViewController, KeyboardProtocol {
    
    private var programVM = ProgramViewModel()
    // 실수로 모달 내렸을 때 작성 중이던 뷰로 올리기 위해
    private var exerciseVM = ExerciseViewModel()
    
    let customView = AddProgramUIView()
    
    var dataClosure: () -> Void = {}
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupCustomView()
        setupKeyborad(self.view)
    }
    
    private func addWorkoutButtonTapped() {
        let vc = AddWorkoutViewController()
        vc.exerciseVM = exerciseVM
        vc.viewDisappear = { [weak self] exerciseVM in
            self?.exerciseVM = exerciseVM
        }
        vc.addButtonTapped = { [weak self] exerciseVM in
            self?.programVM.addExercise(exerciseVM)
            self?.customView.tableView.reloadData()
        }
        self.present(vc, animated: true)
    }
    
    private func searchWorkoutButtonTapped() {
        let vc = SearchWorkoutViewController()
        vc.passWorkoutList = { [weak self] exerciseList in
            exerciseList.forEach { vm in
                self?.programVM.addExercise(vm)
            }
            self?.customView.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setupCustomView() {
        let view = customView
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.programNameTF.delegate = self
        view.addWorkoutButtonAction = addWorkoutButtonTapped
        view.searchWorkoutButtonAction = searchWorkoutButtonTapped
        view.tableView.register(AddProgramTableViewCell.self, forCellReuseIdentifier: Identifier.addProgramTableViewCell)
    }
    
    
}

// MARK: - Navigation Bar

extension AddProgramViewController {
    private func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never // prefersLargeTitle은 딜레이 있어 보임.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(saveButtonDidTapped))
    }
    
    @objc private func saveButtonDidTapped(_ sender: Any) {
        if customView.programNameTF.text == "" || programVM.exercisesVM.count.isZero {
            let alert = UIAlertController(title: "Missing Information", message: "Program should have name \n and at least one workout", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "SAVE", message: "Would you like to save this program?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "No", style: .cancel))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                if action.style == .default {
                    // MARK: - 프로그램 저장 코드 와야함
                    self.programVM.saveProgram()
                    // 이전 뷰에서 reload Data하기 위해서
                    self.dataClosure()
                    self.navigationController?.popViewController(animated: true)
                    
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}


// MARK: - Table View
extension AddProgramViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if programVM.numberOfExercise.isZero {
            tableView.setEmptyMessage("Please add workouts of your program! 🏋️")
        } else {
            tableView.restore()
        }
        return programVM.numberOfExercise
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addProgramTableViewCell, for: indexPath) as! AddProgramTableViewCell
        cell.passData(programVM.exercisesVM[indexPath.row]) 
        return cell
    }
    
    // MARK: - 테이블 삭제
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            programVM.removeExerciseAt(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
}

extension AddProgramViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text else { return }
        programVM.setName(name)
    }
}

