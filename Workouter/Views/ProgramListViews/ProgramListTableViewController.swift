//
//  ProgramListTableViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit

final class ProgramListTableViewController: UITableViewController {
    
    let programListVM = ProgramListViewModel(programsRepository: DefaultProgramsRepository(storage: CoreDataProgramStorage()))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
    }
    
}

// UI
extension ProgramListTableViewController {
    private func setupTableView() {
        tableView.rowHeight = 80
        tableView.register(ProgramListTableViewCell.self, forCellReuseIdentifier: Identifier.programListCell)
    }
    
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
        vc.dataClosure = {
            // AddProgramView에서 추가하고 나올 때 다시 fetch하고 reload
            // TODO: 다음 VC에서 현재 dataClosure로 실행시키는 것들 reactive하게 바꾸기 (아마 다음 뷰컨에 현재 VC의 programlistVM 넘겨줘야할 듯)
            self.programListVM.tempFetchPrograms()
            self.tableView.reloadData()
            
        }
        navigationController?.pushViewController(vc,
                                                 animated: true)
    }
}

extension ProgramListTableViewController: ProgramListViewDelegate {
    func deleteProgram(_ cell: UITableViewCell?) {
        guard let cell, let index = tableView.indexPath(for: cell)?.row else { return }
        programListVM.deleteProgram(index)
        tableView.reloadData()
    }
    
}
