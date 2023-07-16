//
//  WorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit
import AVFoundation
import RxCocoa

final class WorkoutViewController: BaseViewController, KeyboardProtocol {
    
    var viewModel: WorkoutViewModel
    
    init(workouts: [Workout]) {
        self.viewModel = WorkoutViewModel(workouts: workouts)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isSoundOn: Bool {
        return UserDefaults.standard.bool(forKey: Identifier.soundButtonKey)
    }
    
    // 메인 타이머 기능 구현
    var mainTimer: Timer = Timer()
    var mainTimerCount: Int = 0
    var isMainTimerCounting: Bool = true
    var appDidEnterBackgroundDate: Date?
    
    // rest Timer 구현
    var restTimer: Timer = Timer()
    var restTimerCount: Int = 0
    
    // 쉬는 시간 끝났을 때 사운드
    var player: AVAudioPlayer?
    
    var customView = WorkoutUIView()
    
    override func loadView() {
        view = customView
    }
    
    // MARK: - deinit 시키기 (Timer변수를 weak으로 선언할까?)
    override func viewWillDisappear(_ animated: Bool) {
        mainTimer.invalidate()
        restTimer.invalidate()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil, repeats: true)
    //        RunLoop.current.add(mainTimer, forMode: .common)
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupUI() {
        let view = customView
        view.tableView.register(WorkoutSectionCell.self, forCellReuseIdentifier: Identifier.workoutSectionIdentifier)
        view.tableView.register(WorkoutRowCell.self, forCellReuseIdentifier: Identifier.workoutRowIdentifier)
        
        //        setupButtonsUI()
        //        setupNav()
        //        setupTimer()
        setupKeyborad(view)
    }
    
    override func setupDelegate() {
        customView.tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        customView.tableView.rx.setDataSource(self)
            .disposed(by: disposeBag)
        //        customView.tableView.delegate = self
        //        customView.tableView.dataSource = self
    }
    
    override func setupRxBind() {
        let view = customView
        customView.editButtonAction = { view.tableView.isEditing.toggle() }
        viewModel.mainTimerCount
            .map { [weak self] in
                return self?.viewModel.makeTimeTemplate($0) ?? ""
            }
            .subscribe(onNext: { [weak self] in
                self?.customView.mainTimerLabel.text = $0
            })
            .disposed(by: disposeBag)
        
        view.startStopButton.rx.tap
            .bind { self.viewModel.mainTimerStartAndStop() }
            .disposed(by: disposeBag)
        //        customView.doneButtonAction = checkButtonTapped
        //        customView.startStopButtonAction = startAndStopButtonTapped
        //        customView.soundButtonAction = soundButtonTapped
        //        customView.resetButtonAction = restButtonTapped(_:)
        //        setupRestcount()
        
        viewModel.workoutCellsRelay
            .bind { _ in
                    view.tableView.reloadData()
                }
            .disposed(by: disposeBag)
    }
    
}



