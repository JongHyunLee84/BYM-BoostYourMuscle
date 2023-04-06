//
//  WorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit
import AVFoundation

class WorkoutViewController: UIViewController {
    
    var exerciseListVM: [ExerciseViewModel]?
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainTimerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    // Rest Views
    @IBOutlet weak var restTimerLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    var isSoundOn: Bool {
        return UserDefaults.standard.bool(forKey: Identifier.soundButtonKey)
    }
    
    // 메인 타이머 기능 구현
    private var mainTimer: Timer = Timer()
    var mainTimerCount: Int = 0
    var isMainTimerCounting: Bool = true
    var appDidEnterBackgroundDate: Date?
    
    // rest Timer 구현
     var restTimer: Timer = Timer()
     var restTimerCount: Int = 0
    
    // 쉬는 시간 끝났을 때 사운드
    var player: AVAudioPlayer?
    
    // MARK: - deinit 시키기 (Timer변수를 weak으로 선언할까?)
    override func viewWillDisappear(_ animated: Bool) {
        mainTimer.invalidate()
        restTimer.invalidate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil, repeats: true)
        RunLoop.current.add(mainTimer, forMode: .common)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupButtonsUI()
        setupTimer()
        setupTableView()
        setupForKeyBoard()
        setupRestcount()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if tableView.isEditing {
            tableView.isEditing = false
        } else {
            exerciseListVM?.forEach { $0.isOpened = false }
            tableView.reloadData()
            tableView.isEditing.toggle()
        }
    }
    
    // Rest Buttons Tapped
    @IBAction func restButtonTapped(_ sender: UIButton) {
        guard let rest = exerciseListVM?[tableView.indexPathForSelectedRow?.section ?? 0].returnRest() else { return }
        switch sender.tag {
        case 1:
            restTimerCount -= 10
        case 2:
            restTimer.invalidate()
            restTimerLabel.text = "\(rest) sec"
            
        case 3:
            restTimerCount += 10
        default:
            break
        }
    }
    
    // 사운드 음소거 -> 진동
    @IBAction func soundButtonTapped(_ sender: Any) {
        let defaults = UserDefaults.standard
        if isSoundOn == false {
            soundButton.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
            defaults.set(true, forKey: Identifier.soundButtonKey)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
            defaults.set(false, forKey: Identifier.soundButtonKey)
        }
        
    }
    
    // 운동 종료 버튼
    @IBAction func doneButtonTapped(_ sender: UIButton) {
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
    @IBAction func startAndStopButtonTapped(_ sender: UIButton) {
        
        if isMainTimerCounting {
            isMainTimerCounting = false
            mainTimer.invalidate()
            startStopButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        else {
            isMainTimerCounting = true
            startStopButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil, repeats: true)
            RunLoop.current.add(mainTimer, forMode: .common)
        }
    }
    
    @objc func mainTimerCounter() {
        mainTimerCount += 1
        let time = secondsToHoursMinutesSeconds(seconds: mainTimerCount)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        mainTimerLabel.text = timeString
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



