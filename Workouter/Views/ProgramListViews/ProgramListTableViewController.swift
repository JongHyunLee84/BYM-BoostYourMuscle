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
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: Identifier.addProgramVCIdentifier) as! AddProgramViewController
        nextViewController.dataClosure = {
            self.programListVM.fetchProgramVMList()
            self.tableView.reloadData()
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
    
}

extension ProgramListTableViewController: ProgramListViewDelegate {
    func deleteProgram(_ cell: UITableViewCell?) {
        guard let cell, let index = tableView.indexPath(for: cell)?.row else { return }
        programListVM.deleteProgram(index)
        tableView.reloadData()
    }
    
}
