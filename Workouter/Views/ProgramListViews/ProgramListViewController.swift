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
            .bind(to: tableView.rx.items(cellIdentifier: Identifier.programListCell, cellType: ProgramListTableViewCell.self)) { [weak self]
                row, element, cell in
                cell.deleteProgram = { self?.viewModel.deleteProgram(row) }
                cell.passData(element)
            }
            .disposed(by: disposeBag)
        
        viewModel.numberOfRows
            .bind(with: self) { owner, count in
                count.isZero ? owner.tableView.setEmptyMessage(owner.viewModel.emptyMessage) : owner.tableView.restore()
            }
            .disposed(by: disposeBag)
        
        // TODO: WorkoutView 리팩토링할 때 다시 
        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                let program = owner.viewModel.returnViewModelAt(indexPath.row)
                let action1 = UIAlertAction(title: "No", style: .cancel)
                let action2 = UIAlertAction(title: "Yes", style: .default) { _ in
                    // 운동 시작 뷰로 넘어가기
                    let nextViewController = WorkoutViewController(workouts: owner.viewModel.programsRelay.value[indexPath.row].workouts)
                    self.navigationController?.pushViewController(nextViewController, animated: true)
                }
                owner.showAlert(title: program.title, message: owner.viewModel.alertMessage, actions: [action1, action2])
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
