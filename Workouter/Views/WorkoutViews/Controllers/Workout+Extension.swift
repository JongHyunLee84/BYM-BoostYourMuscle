//
//  Workout+Extension.swift
//  BYM
//
//  Created by 이종현 on 2023/04/03.
//

import UIKit
import AVFoundation

// MARK: - 뷰 관련 Extension
extension WorkoutViewController {
    func setupNav() {
        self.navigationController?.isNavigationBarHidden = true
    }
    func setupRestcount() {
        guard let rest = exerciseListVM?[0].returnRest() else { return }
        restTimerLabel.text = "\(rest) sec"
    }
    func setupButtonsUI() {
        if isSoundOn == true {
            soundButton.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
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
        if let indexPath  = tableView.indexPath(for: cell), let exerciseVM = exerciseListVM?[indexPath.section] {
            let pSetVM = exerciseVM.returnPsetAt(indexPath.row - 1)
            tag.isZero ? pSetVM.changeWeight(value) : pSetVM.changeReps(value)
            tableView.reloadData()
        }
    }
    
    func doneButtonTapped() {
        view.endEditing(true)
    }
    func checkButtonTapped(cell: WorkoutRowCell) {
        if let indexPath  = tableView.indexPath(for: cell), let exerciseVM = exerciseListVM?[indexPath.section] {
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
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    @objc func restTimerCounter() {
        restTimerCount -= 1
        restTimerLabel.text = "\(restTimerCount) sec"
        if restTimerCount <= 0 {
            restTimer.invalidate()
            restTimerLabel.text = "Start!"
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




