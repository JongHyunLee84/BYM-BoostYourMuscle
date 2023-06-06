//
//  Workout+Table+Extension.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return exerciseListVM?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let exercise = exerciseListVM?[section] else { return 0 }
        if exercise.isOpened {
            return exercise.sets.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let exerciseListVM else { return UITableViewCell() }
        if indexPath.row.isZero {
            if exerciseListVM[indexPath.section].isOpened {
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.workoutSectionIdentifier) as! WorkoutSectionCell
                cell.workoutNameLabel.text = exerciseListVM[indexPath.section].returnName()
                cell.triangleImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.workoutSectionIdentifier) as! WorkoutSectionCell
                cell.workoutNameLabel.text = exerciseListVM[indexPath.section].returnName()
                cell.triangleImageView.image = UIImage(systemName: "arrowtriangle.right.fill")
                return cell
            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.workoutRowIdentifier) as! WorkoutRowCell
            // MARK: - 바뀐 셀로 데이터 넣어주기
            let pset = exerciseListVM[indexPath.section].sets[indexPath.row - 1]
            cell.delegate = self
            cell.setLabel.text = String(indexPath.row)
            cell.repsTF.text = pset.returnReps()
            cell.weightTF.text = pset.returnWeight()
            let checkButton = cell.checkButton
            pset.returnCheck()  ?
            checkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                                :
            checkButton.setImage(UIImage(systemName: "square"), for: .normal)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exerciseListVM else { return }
        // MARK: - 선택 취소 관련 코드인데 정확히 어떤 기능인지 모르겠음 공부해봐야함.
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row.isZero {
            exerciseListVM[indexPath.section].isOpened.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row.isZero {
            return 65
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row.isZero {
            return true
        } else {
            return false
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        exerciseListVM?.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    // isEditing에서 delete 기능은 없앰
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Identifier.workoutSectionIdentifier, bundle: nil), forCellReuseIdentifier: Identifier.workoutSectionIdentifier)
        tableView.register(UINib(nibName: Identifier.workoutRowIdentifier, bundle: nil), forCellReuseIdentifier: Identifier.workoutRowIdentifier)
    }
}
