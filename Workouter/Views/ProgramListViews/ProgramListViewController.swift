//
//  ProgramListViewController.swift
//  Workouter
//
//  Created by 이종현 on 2023/03/29.
//

import RxCocoa
import RxSwift
import UIKit

final class ProgramListViewController: BaseViewController {
    
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
                let workoutTitle = self.viewModel.returnViewModelAt(indexPath.row).title
                let alert = UIAlertController(title: workoutTitle, message: "Would you like to start exercising \n with this program?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .cancel))
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    if action.style == .default {
                        // 운동 시작 뷰로 넘어가기
                        let nextViewController = WorkoutViewController()
                        let exerciseVM = self.viewModel.returnViewModelAt(indexPath.row).exercises.map { ExerciseViewModel(exercise: $0) }
                        nextViewController.exerciseListVM = exerciseVM
                        self.navigationController?.pushViewController(nextViewController, animated: true)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
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
        vc.addProgram = {[weak self] in self?.viewModel.addProgram($0) }
        navigationController?.pushViewController(vc, animated: true)
    }
}
