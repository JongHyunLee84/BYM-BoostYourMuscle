//
//  WorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit

class WorkoutViewController: UIViewController {

    var exerciseVM: [ExerciseViewModel]?
    @IBOutlet weak var tableView: UITableView!
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
        setupTableView()
        setupForKeyBoard()
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

// 네비게이션 바 없앰, 키보드 내리기
extension WorkoutViewController {
    func setupNav() {
        self.navigationController?.isNavigationBarHidden = true
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
            return 80
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
        if let indexPath  = tableView.indexPath(for: cell) {
            exerciseVM?[indexPath.section].returnSets()[indexPath.row - 1].toggleCheck()
            tableView.reloadRows(at: [indexPath], with: .automatic)
//            tableView.reloadData()
        }
    }

}
