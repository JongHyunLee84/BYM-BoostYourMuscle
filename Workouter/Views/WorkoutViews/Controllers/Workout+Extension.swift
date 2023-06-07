//
//  Workout+Extension.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit
import AVFoundation


// MARK: - CustomView Extension
extension WorkoutViewController {
    
    func setupCustomView() {
        customView.editButtonAction = editButtonTapped
        customView.doneButtonAction = checkButtonTapped
        customView.startStopButtonAction = startAndStopButtonTapped
        customView.soundButtonAction = soundButtonTapped
        customView.resetButtonAction = restButtonTapped(_:)
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        customView.tableView.register(WorkoutSectionCell.self, forCellReuseIdentifier: Identifier.workoutSectionIdentifier)
        customView.tableView.register(WorkoutRowCell.self, forCellReuseIdentifier: Identifier.workoutRowIdentifier)
    }
    
    private func editButtonTapped() {
        let tv = customView.tableView
        if tv.isEditing {
            tv.isEditing = false
        } else {
            exerciseListVM?.forEach { $0.isOpened = false }
            tv.reloadData()
            tv.isEditing.toggle()
        }
    }
    
    // Rest Buttons Tapped
    private func restButtonTapped(_ sender: UIButton) {
        guard let rest = exerciseListVM?[customView.tableView.indexPathForSelectedRow?.section ?? 0].returnRest() else { return }
        switch sender.tag {
        case 1:
            restTimerCount -= 10
        case 2:
            restTimer.invalidate()
            customView.restTimerLabel.text = "\(rest) sec"
            
        case 3:
            restTimerCount += 10
        default:
            break
        }
    }
    
    // 사운드 음소거 -> 진동
    private func soundButtonTapped() {
        let defaults = UserDefaults.standard
        let soundBT = customView.soundButton
        if isSoundOn == false {
            soundBT.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
            defaults.set(true, forKey: Identifier.soundButtonKey)
        } else {
            soundBT.setImage(UIImage(systemName: "speaker"), for: .normal)
            defaults.set(false, forKey: Identifier.soundButtonKey)
        }
        
    }
    
    // 운동 종료 버튼
    private func checkButtonTapped() {
        let alert = UIAlertController(title: "Completion", message: "Have you completed \n your workout session?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            if action.style == .default {
                // MARK: - 운동 종료시 세이브 해야할 코드들
                self.navigationController?.popViewController(animated: true)
                self.navigationController?.isNavigationBarHidden = false
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // 타이머 시작/정지 버튼
    private func startAndStopButtonTapped() {
        let ssBT = customView.startStopButton
        if isMainTimerCounting {
            isMainTimerCounting = false
            mainTimer.invalidate()
            ssBT.setImage(UIImage(systemName: "play.circle", withConfiguration: ssBT.currentImage?.configuration), for: .normal)
        }
        else {
            isMainTimerCounting = true
            ssBT.setImage(UIImage(systemName: "pause.circle", withConfiguration: ssBT.currentImage?.configuration), for: .normal)
            mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil, repeats: true)
            RunLoop.current.add(mainTimer, forMode: .common)
        }
    }
    
    @objc func mainTimerCounter() {
        mainTimerCount += 1
        let time = secondsToHoursMinutesSeconds(seconds: mainTimerCount)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        customView.mainTimerLabel.text = timeString
    }
    
    private func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    private func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}


// MARK: - 뷰 관련 Extension
extension WorkoutViewController {
    
    func setupNav() {
        self.navigationController?.isNavigationBarHidden = true
    }
    func setupRestcount() {
        guard let rest = exerciseListVM?[0].returnRest() else { return }
        customView.restTimerLabel.text = "\(rest) sec"
    }
    func setupButtonsUI() {
        let soundBT = customView.soundButton
        if isSoundOn == true {
            soundBT.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        } else {
            soundBT.setImage(UIImage(systemName: "speaker"), for: .normal)
        }
    }
    // 타이머가 백그라운드에서도 동작하게 하는 코드
    func setupTimer() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func applicationDidEnterBackground() {
        // 타이머가 작동 중일 때만 백그라운드 대응을 하게 만든 guard
        guard isMainTimerCounting else { return }
                self.appDidEnterBackgroundDate = Date()
    }

    @objc func applicationWillEnterForeground() {
        // 타이머가 작동 중일 때만 백그라운드 대응을 하게 만든 guard
        guard isMainTimerCounting else { return }
        guard let previousDate = appDidEnterBackgroundDate else { return }
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
        let seconds = difference.second!
        // 실제 타이머와 비교했을 때 background -> foreground 과정에서 1초 정도 오차가 있어서 빼줌
        mainTimerCount += seconds - 1
    }
}

// MARK: - Cell Delegate Extension
extension WorkoutViewController: WorkoutRowCellDelegate {
    
    // 무게 or 횟수가 운동 중에 수정되면 해당 model의 바뀐 값을 다시 저장
    func textFieldDidEndEditing(cell: WorkoutRowCell, tag: Int, value: String) {
        let tv = customView.tableView
        if let indexPath  = tv.indexPath(for: cell), let exerciseVM = exerciseListVM?[indexPath.section] {
            let pSetVM = exerciseVM.returnPsetAt(indexPath.row - 1)
            tag.isZero ? pSetVM.changeWeight(value) : pSetVM.changeReps(value)
            tv.reloadData()
        }
    }
    
    func keyboardDoneButtonTapped() {
        view.endEditing(true)
    }
    func checkButtonTapped(cell: WorkoutRowCell) {
        let tv = customView.tableView
        if let indexPath  = tv.indexPath(for: cell), let exerciseVM = exerciseListVM?[indexPath.section] {
            let pSet = exerciseVM.sets[indexPath.row - 1]
            pSet.toggleCheck()
            // 체크 버튼 눌렸을 때 휴식 타이머 기능 시작
            if let pSet = exerciseListVM?[indexPath.section].sets[indexPath.row - 1], pSet.returnCheck()  {
                // 체크할 때마다 Timer가 연속으로 할당되니까 매번 invalidate 시킴
                restTimer.invalidate()
                restTimerCount = exerciseVM.returnRest()
                restTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restTimerCounter), userInfo: nil, repeats: true)
                // 타이머가 테이블 뷰, 드래그 등등 UI Interacting이 있을 때 멈추는 것처럼 보이는 증상을 RunLoop의 모드를 default -> common으로 바꿔주며 해결
                RunLoop.current.add(restTimer, forMode: .common)
            }
            tv.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func restTimerCounter() {
        let restTimerLB = customView.restTimerLabel
        restTimerCount -= 1
        restTimerLB.text = "\(restTimerCount) sec"
        if restTimerCount <= 0 {
            restTimer.invalidate()
            restTimerLB.text = "Start!"
            if isSoundOn {
                playSound()
            } else {
                // 진동
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            }
        }
    }
}

// MARK: - Timer + (Play Sound and Vibrate) Extension
extension WorkoutViewController {
    func playSound() {
        guard let url = Bundle.main.url(forResource: "ES_Boxing Bell Ring 2 - SFX Producer", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            
            guard let player = player else { return }
            
            player.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}




