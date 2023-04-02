//
//  WorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit
import AVFoundation




class WorkoutViewController: UIViewController {
    
    var exerciseVM: [ExerciseViewModel]?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainTimerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    // Rest Views
    @IBOutlet weak var restTimerLabel: UILabel!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    private var soundButtonToggle: Bool = true
    // 메인 타이머 기능 구현
    private var mainTimer: Timer = Timer()
    private var mainTimerCount: Int = 0
    private var isMainTimerCounting: Bool = true
    private var appDidEnterBackgroundDate: Date?
    
    // rest Timer 구현
    private var restTimer: Timer = Timer()
    private var restTimerCount: Int = 0
    
    // 쉬는 시간 끝났을 때 사운드
    var player: AVAudioPlayer?
    
    override func viewWillAppear(_ animated: Bool) {
        mainTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(mainTimerCounter), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupResetButtons()
        setupTimer()
        setupTableView()
        setupForKeyBoard()
    }
    
    // Rest Buttons Tapped
    @IBAction func restButtonTapped(_ sender: UIButton) {
        
    }
    
    // 사운드 음소거 -> 진동
    @IBAction func soundButtonTapped(_ sender: Any) {
        soundButtonToggle.toggle()
        if soundButtonToggle {
            soundButton.setImage(UIImage(systemName: "speaker.wave.2"), for: .normal)
        } else {
            soundButton.setImage(UIImage(systemName: "speaker"), for: .normal)
        }
    }
    
    // 운동 종료 버튼
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Completion", message: "Have you completed \n your workout session?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            if action.style == .default {
                // 운동 종료시 세이브 해야할 코드들
                self.navigationController?.popViewController(animated: true)
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
        }
    }
    
    @objc func mainTimerCounter() {
        mainTimerCount += 1
        let time = secondsToHoursMinutesSeconds(seconds: mainTimerCount)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        mainTimerLabel.text = timeString
    }
    
    @objc func restTimerCounter() {
        restTimerCount -= 1
        restTimerLabel.text = "\(restTimerCount) sec"
        if restTimerCount == 0 {
            restTimer.invalidate()
            restTimerLabel.text = "Start!"
            if soundButtonToggle {
                playSound()
            } else {
                // 진동
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            }
        }
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
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

// 네비게이션 바 없앰, 키보드 내리기
extension WorkoutViewController {
    func setupNav() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupResetButtons() {
        minusButton.layer.cornerRadius = 10
        minusButton.layer.masksToBounds = true
        resetButton.layer.cornerRadius = 10
        resetButton.layer.masksToBounds = true
        plusButton.layer.cornerRadius = 10
        plusButton.layer.masksToBounds = true
    }
    // 뷰 아무 곳 터치시 키보드 내리기
    func setupForKeyBoard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
}

// MARK: - 테이블뷰 관련 코드

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return exerciseVM?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let exercise = exerciseVM?[section] else { return 0 }
        if exercise.isOpened {
            return exercise.returnSets().count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let exerciseVM else { return UITableViewCell() }
        if indexPath.row == 0 {
            if exerciseVM[indexPath.section].isOpened {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.workoutSectionIdentifier) as! WorkoutSectionCell
                cell.workoutNameLabel.text = exerciseVM[indexPath.section].returnName()
                cell.triangleImageView.image = UIImage(systemName: "arrowtriangle.down.fill")
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.workoutSectionIdentifier) as! WorkoutSectionCell
                cell.workoutNameLabel.text = exerciseVM[indexPath.section].returnName()
                cell.triangleImageView.image = UIImage(systemName: "arrowtriangle.right.fill")
                return cell
            }

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.workoutRowIdentifier) as! WorkoutRowCell
            // MARK: - 바뀐 셀로 데이터 넣어주기
            let pset = exerciseVM[indexPath.section].returnSets()[indexPath.row - 1]
            cell.delegate = self
            cell.setLabel.text = String(indexPath.row)
            cell.repsTF.text = pset.returnReps()
            cell.weightTF.text = pset.returnWeight()
            let checkButton = cell.checkButton
            pset.returnCheck()  ?
                                checkButton?.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                                :
                                checkButton?.setImage(UIImage(systemName: "square"), for: .normal)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exerciseVM else { return }
        // MARK: - 선택 취소 관련 코드인데 정확히 어떤 기능인지 모르겠음 공부해봐야함.
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            exerciseVM[indexPath.section].isOpened.toggle()
            tableView.reloadSections([indexPath.section], with: .none)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 65
        }
        return 50
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.workoutSectionIdentifier, bundle: nil), forCellReuseIdentifier: Cell.workoutSectionIdentifier)
        tableView.register(UINib(nibName: Cell.workoutRowIdentifier, bundle: nil), forCellReuseIdentifier: Cell.workoutRowIdentifier)
    }
}

extension WorkoutViewController: WorkoutRowCellDelegate {
    func doneButtonTapped() {
        view.endEditing(true)
    }

    func checkButtonTapped(cell: WorkoutRowCell) {
        if let indexPath  = tableView.indexPath(for: cell), let exercise = exerciseVM?[indexPath.section] {
            let pSet = exercise.returnSets()[indexPath.row - 1]
            pSet.toggleCheck()
            // 체크 버튼 눌렸을 때 휴식 타이머 기능 시작
            if let pSet = exerciseVM?[indexPath.section].returnSets()[indexPath.row - 1], pSet.returnCheck()  {
                // 체크할 때마다 Timer가 연속으로 할당되니까 매번 invalidate 시킴
                restTimer.invalidate()
                restTimerCount = 3  //exercise.returnRest()
                restTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(restTimerCounter), userInfo: nil, repeats: true)
            }
            
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }

}

// bell sound extension
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

