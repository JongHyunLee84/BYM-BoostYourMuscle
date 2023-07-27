//
//  WorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import RxCocoa
import UIKit

final class WorkoutViewController: BaseViewController, KeyboardProtocol, Alertable {
    
    var viewModel: WorkoutViewModel
    
    init(workouts: [Workout]) {
        self.viewModel = WorkoutViewModel(workouts: workouts)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var customView = WorkoutUIView()
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        self.navigationController?.isNavigationBarHidden = true
        let view = customView
        view.tableView.register(WorkoutSectionCell.self, forCellReuseIdentifier: Identifier.workoutSectionIdentifier)
        view.tableView.register(WorkoutRowCell.self, forCellReuseIdentifier: Identifier.workoutRowIdentifier)
        setupKeyborad(view)
    }
    
    override func setupDelegate() {
        customView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        customView.tableView.rx.setDataSource(self)
            .disposed(by: disposeBag)
    }
    
    override func setupRxBind() {
        let view = customView
        
        viewModel.mainTimerCount
            .map { [weak self] in
                return self?.viewModel.makeTimeTemplate($0) ?? ""
            }
            .bind(to: view.mainTimerLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isMainTimerCounting
            .bind { _ in
                let configuration = view.startStopButton.currentImage?.configuration // 현재 configuration 설정 안 해주면 자꾸 작아짐
                view.startStopButton.setImage(UIImage(systemName: self.viewModel.mainTimerImageName, withConfiguration: configuration), for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.isEditingTableView
            .bind {
                view.tableView.reloadData()
                view.tableView.isEditing = $0
            }
            .disposed(by: disposeBag)
        
        viewModel.isSoundOn
            .bind { _ in
                view.soundButton.setImage(UIImage(systemName: self.viewModel.soundButtonImageName), for: .normal)
            }
            .disposed(by: disposeBag)
        
        viewModel.restTimerCount
            .map { $0.toSecond }
            .bind(to: view.restTimerLabel.rx.text)
            .disposed(by: disposeBag)
        
        view.startStopButton.rx.tap
            .bind { self.viewModel.toggleBoolValue(.mainTimer) }
            .disposed(by: disposeBag)
        
        view.editButton.rx.tap
            .bind { self.viewModel.toggleBoolValue(.tableView) }
            .disposed(by: disposeBag)

        view.soundButton.rx.tap
            .bind { self.viewModel.toggleBoolValue(.sound) }
            .disposed(by: disposeBag)
        
        view.minusButton.rx.tap
            .bind { self.viewModel.restTimerCountChange(-10) }
            .disposed(by: disposeBag)
        
        view.plusButton.rx.tap
            .bind { self.viewModel.restTimerCountChange(10) }
            .disposed(by: disposeBag)
            
        view.doneButton.rx.tap
            .bind {
                let noAction = UIAlertAction(title: "No", style: .cancel)
                let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                    // MARK: - 운동 종료시 세이브 해야할 코드들 들어와야 함.
                    self.navigationController?.popViewController(animated: true)
                    self.navigationController?.isNavigationBarHidden = false // 현재 뷰뿐만 아니라 이전 뷰까지 네비게이션 바가 없어지는 현상 때문에
                }
                self.showAlert(title: self.viewModel.alertTitle, message: self.viewModel.alertMessage, actions: [noAction, yesAction])
            }
            .disposed(by: disposeBag)

        view.resetButton.rx.tap
            .bind {
                self.viewModel.restTimerCountReset()
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.didEnterBackgroundNotification)
            .bind { _ in
                self.viewModel.applicationDidEnterBackground()
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIApplication.willEnterForegroundNotification)
            .bind { _ in
                self.viewModel.applicationWillEnterForeground()
            }
            .disposed(by: disposeBag)
    }
    
}

// MARK: - Cell Delegate Extension
extension WorkoutViewController: WorkoutRowCellDelegate {
    
    // rx의 controlEvent에 똑같이 동작하는 것이 없어서 그냥 delegate 사용
    func textFieldDidEndEditing(cell: WorkoutRowCell, tag: Int, value: String) {
        if let indexPath = customView.tableView.indexPath(for: cell), let value = Double(value) {
            self.viewModel.changeSetVolume(at: indexPath, to: value, which: tag.isZero ? .weight : .reps)
        }
    }
    
    func keyboardDoneButtonTapped() {
        view.endEditing(true)
    }
}


