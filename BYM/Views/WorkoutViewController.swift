//
//  WorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit

class WorkoutViewController: UIViewController {

    var programVM: ProgramViewModel?
    private var tableView: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    // 타이머 기능 구현
    private var timer: Timer = Timer()
    private var count: Int = 0
    private var isTimerCounting: Bool = true
    private var appDidEnterBackgroundDate: Date?

    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        setupTimer()
    }
    
    // 운동 종료 버튼
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Completion", message: "Have you completed your workout session?", preferredStyle: .alert)
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
        
        if isTimerCounting {
            isTimerCounting = false
            timer.invalidate()
            startStopButton.setImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        else {
            isTimerCounting = true
            startStopButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerCounter() -> Void {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
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
        guard isTimerCounting else { return }
                self.appDidEnterBackgroundDate = Date()
    }

    @objc func applicationWillEnterForeground() {
        // 타이머가 작동 중일 때만 백그라운드 대응을 하게 만든 guard
        guard isTimerCounting else { return }
        guard let previousDate = appDidEnterBackgroundDate else { return }
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
        let seconds = difference.second!
        // 실제 타이머와 비교했을 때 background -> foreground 과정에서 1초 정도 오차가 있어서 빼줌
        count += seconds - 1
    }
}

// 네비게이션 바 없앰
extension WorkoutViewController {
    func setupNav() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

extension WorkoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

