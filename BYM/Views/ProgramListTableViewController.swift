//
//  ProgramListTableViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit

final class ProgramListTableViewController: UITableViewController {
    
    private let programListVM = ProgramListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        programSamples.forEach { pr in
            programListVM.addProgram(ProgramViewModel(program: pr))
        }
    }
    
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return programListVM.numberOfRows()
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ProgramListCell", for: indexPath) as!  ProgramListTableViewCell
        cell.delegate = self
        cell.programTitleLabel.text = programListVM.modelAt(indexPath.row).returnTitle()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell이 선택되면 alert 띄우기
        let workoutTitle = programListVM.modelAt(indexPath.row).returnTitle()
        let alert = UIAlertController(title: workoutTitle, message: "Would you like to start exercising with this program?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            if action.style == .default {
                // 운동 시작 뷰로 넘어가기
                self.performSegue(withIdentifier: "WorkoutViewController", sender: self)
            }
            }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // WorkoutViewController로 넘어갈 때 데이터 전달을 위한 메서드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WorkoutViewController", let selectedRow = tableView.indexPathForSelectedRow?.row {
            let workoutVC = segue.destination as! WorkoutViewController
            // 데이터 전달
            workoutVC.programVM = programListVM.modelAt(selectedRow)
        }
    }

}

extension ProgramListTableViewController: ProgramListViewDelegate {
    
    func editButtonTapped() {
        print("edit button Tapped")
    }
    
}
