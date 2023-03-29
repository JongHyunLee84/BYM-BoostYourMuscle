//
//  WorkoutViewController.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import UIKit

class WorkoutViewController: UIViewController {

    var programVM: ProgramViewModel?
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    
    // 타이머 기능 구현
    var timer: Timer = Timer()
    var count: Int = 0
    var timerCounting: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
    }
    
    @IBAction func startAndStopButtonTapped(_ sender: UIButton) {
        
        if timerCounting {
            timerCounting = false
            timer.invalidate()
            startStopButton.setImage(UIImage(systemName: "play.circle"), for: .normal)

        }
        else {
            timerCounting = true
            startStopButton.setImage(UIImage(systemName: "pause.circle"), for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerCounter() -> Void
    {
        count = count + 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        timerLabel.text = timeString
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int)
    {
        return ((seconds / 3600), ((seconds % 3600) / 60),((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds : Int) -> String
    {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
    

}

extension WorkoutViewController {
    func setupNav() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
