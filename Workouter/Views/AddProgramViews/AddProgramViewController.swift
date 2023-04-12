//
//  AddProgramViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit



class AddProgramViewController: UIViewController {
    private var programVM: ProgramViewModel = ProgramViewModel()

    // 실수로 모달 내렸을 때 작성 중이던 뷰로 올리기 위해
    private var exerciseVM: ExerciseViewModel = ExerciseViewModel()
    @IBOutlet weak var programNameTF: UITextField!
    @IBOutlet weak var addWorkoutButton: UIButton!
    @IBOutlet weak var searchWorkoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var dataClosure: () -> Void = {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupForKeyBoard()
        setupTableView()
        setupTF()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if programNameTF.text == "" || programVM.exercisesVM.count.isZero {
            let alert = UIAlertController(title: "Missing Information", message: "Program should have name \n and at least on workout", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == Identifier.toAddWorkoutViewController {
            let vc = segue.destination as! AddWorkoutViewController
            vc.exerciseVM = self.exerciseVM
            vc.viewDisappear =  { [weak self] exerciseVM in
                self?.exerciseVM = exerciseVM
            }
            vc.addButtonTapped = { [weak self] exerciseVM in
                self?.programVM.addExercise(exerciseVM)
                self?.tableView.reloadData()
            }
        } else if segue.identifier == Identifier.searchWorkoutViewController {
            let vc = segue.destination as! SearchWorkoutViewController
            vc.passWorkoutList = { [weak self] exerciseList in
                exerciseList.forEach { vm in
                    self?.programVM.addExercise(vm)
                }
                self?.tableView.reloadData()
            }

        }
        
    }
    
    

    
}

// MARK: - Setup Extension
extension AddProgramViewController {
    func setupUI() {
        addWorkoutButton.layer.cornerRadius = 8
        addWorkoutButton.layer.masksToBounds = true
        searchWorkoutButton.layer.cornerRadius = 8
        searchWorkoutButton.layer.masksToBounds = true
        
    }
    
    // 뷰 아무 곳 터치시 키보드 내리기
    func setupForKeyBoard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

// MARK: - Table View
extension AddProgramViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
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
        cell.setupUI(programVM.exercisesVM[indexPath.row])
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

// MARK: - Text Field Extension

extension AddProgramViewController: UITextFieldDelegate {
    
    func setupTF() {
        programNameTF.delegate = self
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let name = textField.text else { return }
        programVM.setName(name)
    }
    
}

