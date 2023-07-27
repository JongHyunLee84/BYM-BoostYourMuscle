//
//  Workout+Table+Extension.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import RxCocoa
import RxSwift
import UIKit

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    
    //     MARK: - datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.workoutCellsRelay.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let workoutCell = viewModel.workoutCellsRelay.value[section]
        return workoutCell.isExpanded ? workoutCell.sets.count + 1 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row.isZero {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.workoutSectionIdentifier) as! WorkoutSectionCell
            let (name, isExpaneded) = viewModel.workoutSectionCellData(indexPath)
            cell.passData((name, isExpaneded))
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifier.workoutRowIdentifier) as! WorkoutRowCell
            cell.delegate = self
            cell.passData(viewModel.workoutRowCellData(indexPath))
            // TODO: 아래 코드들 적용되는지 테스트 (배열 통해서 하나로 줄일 수 있으면 줄이기)
            cell.checkButton.rx.tap
                .bind {
                    self.viewModel.checkButtonTapped(indexPath: indexPath)
                    cell.passData(self.viewModel.workoutRowCellData(indexPath))
                }
                .disposed(by: disposeBag)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row.isZero ? true : false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.swapElement(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    // MARK: - delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: - 선택 취소 관련 코드인데 정확히 어떤 기능인지 모르겠음 공부해봐야함.
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row.isZero {
            viewModel.expandSection(at: indexPath)
            tableView.reloadSections([indexPath.section], with: .none)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row.isZero ? 65 : 50
    }
    
    // isEditing에서 delete 기능은 없앰
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .none
    }
    
}
