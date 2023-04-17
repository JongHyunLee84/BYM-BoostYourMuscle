//
//  ProgramListTableViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit

final class ProgramListTableViewController: UITableViewController {
    
    let programListVM = ProgramListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.addProgramViewController {
            let vc = segue.destination as! AddProgramViewController
            vc.dataClosure = {
                self.programListVM.fetchProgramVMList()
                self.tableView.reloadData()
            }
            
        }
    }
    
}

extension ProgramListTableViewController: ProgramListViewDelegate {
    func deleteProgram(_ cell: UITableViewCell?) {
        guard let cell, let index = tableView.indexPath(for: cell)?.row else { return }
        programListVM.deleteProgram(index)
        tableView.reloadData()
    }
    
}
