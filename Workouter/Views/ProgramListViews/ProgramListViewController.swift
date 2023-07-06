//
//  ProgramListViewController.swift
//  Workouter
//
//  Created by 이종현 on 2023/03/29.
//

import RxCocoa
import RxSwift
import UIKit

final class ProgramListViewController: BaseViewController, Alertable {
    
    let viewModel = ProgramListViewModel(programsRepository: DefaultProgramsRepository(storage: CoreDataProgramStorage()))
    
    let tableView = UITableView()
    
    override func loadView() {
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupRxBind() {
        viewModel.programsRelay
            .bind(to: tableView.rx.items(cellIdentifier: Identifier.programListCell, cellType: ProgramListTableViewCell.self)) {
                row, element, cell in
                cell.deleteProgram = { self.viewModel.deleteProgram(row) }
                cell.passData(element)
            }
            .disposed(by: disposeBag)
        
        viewModel.numberOfRows
            .bind { count in
                count.isZero ? self.tableView.setEmptyMessage(self.viewModel.emptyMessage) : self.tableView.restore()
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind { indexPath in
                let program = self.viewModel.returnViewModelAt(indexPath.row)
                let action1 = UIAlertAction(title: "No", style: .cancel)
                let action2 = UIAlertAction(title: "Yes", style: .default) { _ in
                    // 운동 시작 뷰로 넘어가기
                    let nextViewController = WorkoutViewController()
                    let exerciseVM = program.exercises.map { ExerciseViewModel(exercise: $0) }
                    nextViewController.exerciseListVM = exerciseVM
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                self.showAlert(title: program.title, message: self.viewModel.alertMessage, actions: [action1, action2])
            }
            .disposed(by: disposeBag)
        
    }
    override func setupUI() {
        setupNavigationBar()
        tableView.rowHeight = 80
        tableView.register(ProgramListTableViewCell.self, forCellReuseIdentifier: Identifier.programListCell)
    }
    
}

// UI
extension ProgramListViewController {
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Programs"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                                 style: .done,
                                                                 target: self,
                                                                 action: #selector(addButtonDidTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = .dynamicColor
        
    }
    
    @objc private func addButtonDidTapped() {
        let vc = AddProgramViewController()
        vc.addProgram = { [weak self] in self?.viewModel.addProgram($0) }
        navigationController?.pushViewController(vc, animated: true)
    }
}
