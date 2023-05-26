//
//  AddProgramViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

class AddProgramViewController: UIViewController {
    
    private var programVM = ProgramViewModel()
    // 실수로 모달 내렸을 때 작성 중이던 뷰로 올리기 위해
    private var exerciseVM = ExerciseViewModel()
    
    private lazy var customView: AddProgramUIView = {
        let view = AddProgramUIView()
        view.programVM = programVM
        view.tableview.delegate = self
        view.tableview.dataSource = self
        view.addWorkoutButtonAction = addWorkoutButtonTapped
        view.searchWorkoutButtonAction = searchWorkoutButtonTapped
        return view
    }()
    
    var dataClosure: () -> Void = {}
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
    
    private func addWorkoutButtonTapped() {
        let vc = AddWorkoutViewController()
        vc.exerciseVM = exerciseVM
        vc.viewDisappear = { [weak self] exerciseVM in
            self?.exerciseVM = exerciseVM
        }
        vc.addButtonTapped = { [weak self] exerciseVM in
            self?.programVM.addExercise(exerciseVM)
            self?.customView.tableview.reloadData()
        }
        self.present(vc, animated: true)
    }
    
    private func searchWorkoutButtonTapped() {
        let vc = SearchWorkoutViewController()
        vc.passWorkoutList = { [weak self] exerciseList in
            exerciseList.forEach { vm in
                self?.programVM.addExercise(vm)
            }
            self?.customView.tableview.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }

    
}

// MARK: - Navigation Bar

extension AddProgramViewController {
    private func setupNavigation() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(saveButtonDidTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .black
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    @objc private func saveButtonDidTapped(_ sender: Any) {
        if customView.programNameTF.text == "" || programVM.exercisesVM.count.isZero {
            let alert = UIAlertController(title: "Missing Information", message: "Program should have name \n and at least on workout", preferredStyle: .alert)
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
        cell.exerciseVM = programVM.exercisesVM[indexPath.row]
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



