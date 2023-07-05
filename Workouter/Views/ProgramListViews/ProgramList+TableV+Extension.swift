//
//  ProgramListTableView+Extension.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//

import Foundation
import UIKit

// MARK: - 테이블 뷰 관련 extension
extension ProgramListTableViewController {
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if programListVM.numberOfRows.value.isZero {
            tableView.setEmptyMessage("You don't have any program yet. \n please tap add button to save program 💪")
        } else {
            tableView.restore()
        }
        return programListVM.numberOfRows.value
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.programListCell, for: indexPath) as!  ProgramListTableViewCell
        cell.delegate = self
        cell.passData(programListVM.returnViewModelAt(indexPath.row))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // cell이 선택되면 alert 띄우기
        let workoutTitle = programListVM.returnViewModelAt(indexPath.row).title
        let alert = UIAlertController(title: workoutTitle, message: "Would you like to start exercising \n with this program?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            if action.style == .default {
                // 운동 시작 뷰로 넘어가기
                let nextViewController = WorkoutViewController()
                let exerciseVM = self.programListVM.returnViewModelAt(indexPath.row).exercises.map { ExerciseViewModel(exercise: $0) }
                nextViewController.exerciseListVM = exerciseVM
                self.navigationController?.pushViewController(nextViewController, animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
