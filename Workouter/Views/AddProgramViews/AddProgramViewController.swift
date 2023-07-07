//
//  AddProgramViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//
import RxSwift
import RxCocoa
import UIKit

final class AddProgramViewController: BaseViewController, KeyboardProtocol, Alertable {
    
    private var viewModel = ProgramViewModel()
    
    let customView = AddProgramUIView()
    var addProgram: (Program) -> Void = { program in } // 이전 뷰와 바인딩을 위한 클로저
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupDelegate() {
        let view = customView
        view.tableView.delegate = self
        view.tableView.register(AddProgramTableViewCell.self, forCellReuseIdentifier: Identifier.addProgramTableViewCell)
    }
    
    override func setupRxBind() {
        let view = customView
        
        view.addWorkoutButton.rx.tap
            .bind {
                let vc = AddWorkoutViewController()
                vc.viewDisappear = { [weak self] exerciseVM in
                    self?.viewModel.exercise = exerciseVM
                }
                vc.addButtonTapped = { [weak self] exercise in
                    self?.viewModel.addExercise(exercise)
                    self?.customView.tableView.reloadData()
                }
                self.present(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        view.searchWorkoutButton.rx.tap
            .bind {
                let vc = SearchWorkoutViewController()
                vc.passWorkoutList = { [weak self] exerciseList in
                    exerciseList.forEach { vm in
                        //TODO: searchview 리팩토링할때 수정해야할듯
                        //                self?.viewModel.addExercise(vm)
                    }
                    self?.customView.tableView.reloadData()
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }
            .disposed(by: disposeBag)
        
        view.programNameTF.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(to: viewModel.titleRelay)
            .disposed(by: disposeBag)
        
        navigationItem.rightBarButtonItem?.rx.tap
            .flatMap { [weak self] () -> Observable<(Bool, Program)> in
                guard let self = self else { return Observable.empty() }
                return Observable.combineLatest(self.viewModel.isSavable, self.viewModel.programRelay)
            }
            .bind(onNext: { isTrue, program in
                if isTrue {
                    let noAction = UIAlertAction(title: "No", style: .cancel)
                    let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { _ in
                        // MARK: - 프로그램 저장 코드 와야함
                        self.viewModel.saveProgram() // coredata 저장
                        self.addProgram(program) // 이전 뷰와 바인딩하기 위한 클로저
                        self.navigationController?.popViewController(animated: true)
                        
                    })
                    self.showAlert(title: self.viewModel.saveAlert.title, message: self.viewModel.saveAlert.message, actions: [noAction, yesAction])
                }else {
                    self.showAlert(title: self.viewModel.rejectAlert.title, message: self.viewModel.rejectAlert.message, actions: nil)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.exercisesRelay
            .bind(to: view.tableView.rx.items(cellIdentifier: Identifier.addProgramTableViewCell, cellType: AddProgramTableViewCell.self)) {
                row, item, cell in
                cell.passData(self.viewModel.exercisesRelay.value[row])
            }
            .disposed(by: disposeBag)
        
        viewModel.numberOfExercises
            .bind {
                $0.isZero ? self.customView.tableView.setEmptyMessage(self.viewModel.emptyMessage) : self.customView.tableView.restore()
            }
            .disposed(by: disposeBag)
    }
    
    override func setupUI() {
        setupNavigation()
        setupKeyborad(self.view)
    }
    
}

// MARK: - Navigation Bar

extension AddProgramViewController {
    private func setupNavigation() {
        navigationItem.largeTitleDisplayMode = .never // prefersLargeTitle은 딜레이 있어 보임.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: nil)
    }
}

//    // MARK: - 테이블 삭제
extension AddProgramViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            viewModel.removeExerciseAt(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

//        view.tableView.dataSource = self
//        view.programNameTF.delegate = self

//        view.addWorkoutButtonAction = addWorkoutButtonTapped
//        view.searchWorkoutButtonAction = searchWorkoutButtonTapped

// MARK: - Table View
//extension AddProgramViewController: UITableViewDelegate, UITableViewDataSource {

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if viewModel.numberOfExercise.isZero {
//            tableView.setEmptyMessage("Please add workouts of your program! 🏋️")
//        } else {
//            tableView.restore()
//        }
//        return viewModel.numberOfExercise
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.addProgramTableViewCell, for: indexPath) as! AddProgramTableViewCell
//        //TODO: rxcocoa로 리팩토링 필요
//        cell.passData(viewModel.program.exercises[indexPath.row])
//        return cell
//    }

//extension AddProgramViewController: UITextFieldDelegate {
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        guard let name = textField.text else { return }
//        viewModel.setName(name)
//    }
//}

//    private func addWorkoutButtonTapped() {
//        let vc = AddWorkoutViewController()
//        vc.viewDisappear = { [weak self] exerciseVM in
//            self?.viewModel.exercise = exerciseVM
//        }
//        vc.addButtonTapped = { [weak self] exercise in
//            self?.viewModel.addExercise(exercise)
//            self?.customView.tableView.reloadData()
//        }
//        self.present(vc, animated: true)
//    }

//    private func searchWorkoutButtonTapped() {
//        let vc = SearchWorkoutViewController()
//        vc.passWorkoutList = { [weak self] exerciseList in
//            exerciseList.forEach { vm in
//                //TODO: searchview 리팩토링할때 수정해야할듯
////                self?.viewModel.addExercise(vm)
//            }
//            self?.customView.tableView.reloadData()
//        }
//        navigationController?.pushViewController(vc, animated: true)
//    }

//    @objc private func saveButtonDidTapped(_ sender: Any) {
//        if customView.programNameTF.text == "" || viewModel.programRelay.exercises.count.isZero {
//            let alert = UIAlertController(title: "Missing Information", message: "Program should have name \n and at least one workout", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
//            self.present(alert, animated: true, completion: nil)
//        }else {
//            let alert = UIAlertController(title: "SAVE", message: "Would you like to save this program?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "No", style: .cancel))
//            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {[weak self] action in
//                if action.style == .default {
//                    // MARK: - 프로그램 저장 코드 와야함
//                    self?.viewModel.saveProgram() // coredata 저장
//                    if let program = self?.viewModel.programRelay { self?.addProgram(program) } // 이전 뷰와 바인딩하기 위한 클로저
//                    self?.navigationController?.popViewController(animated: true)
//                }
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//    }
