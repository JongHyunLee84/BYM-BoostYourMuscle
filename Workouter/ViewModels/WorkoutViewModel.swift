//
//  WorkoutViewModel.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/13.
//

import AudioToolbox
import AVFoundation
import RxRelay
import RxSwift

struct WorkoutCellType {
    let name: String
    let rest: Int
    var sets: [SetVolume]
    var isExpanded: Bool
    
    init(_ workout: Workout){
        name = workout.name
        rest = workout.rest
        sets = workout.sets
        isExpanded = false
    }
    
    // isExpanded를 모두 false로 만들어 확장된 tableview를 축소시키기 위한 코드
    init(_ workoutCellType: WorkoutCellType) {
        name = workoutCellType.name
        rest = workoutCellType.rest
        sets = workoutCellType.sets
        isExpanded = false
    }
}

final class WorkoutViewModel {
    
    let disposeBag = DisposeBag()
    
    let workoutCellsRelay: BehaviorRelay<[WorkoutCellType]>
    
    // MARK: - Main Timer
    let isMainTimerCounting = BehaviorRelay(value: true)
    let mainTimerCount = BehaviorRelay(value: 0)
    var didEnterBackgroundDate = Date()
    var mainTimerImageName: String {
        isMainTimerCounting.value == true ? "pause.circle" : "play.circle"
    }
    // MARK: - Rest Timer
    let isRestTimerCounting = BehaviorRelay(value: false)
    let restTimerCount: BehaviorRelay<Int>
    let resetCount: BehaviorRelay<Int> // 진행 중인 운동의 원래 쉬는 시간
    // MARK: - Etc..
    let isEditingTableView = BehaviorRelay(value: false)
    let isSoundOn: BehaviorRelay<Bool>
    var audioPlayer: AVAudioPlayer?
    var soundButtonImageName: String {
        isSoundOn.value == true ? "speaker.wave.2" : "speaker"
    }
    let alertTitle = "Completion"
    let alertMessage = "Have you completed \n your workout session?"
    
    init(workouts: [Workout]) {
        // MARK: - init
        let workoutCellTypes = workouts.map { WorkoutCellType($0) }
        workoutCellsRelay = BehaviorRelay(value: workoutCellTypes)
        restTimerCount = BehaviorRelay(value: workoutCellTypes[0].rest)
        resetCount = BehaviorRelay(value: workoutCellTypes[0].rest)
        isSoundOn = BehaviorRelay(value: UserDefaults.standard.bool(forKey: Identifier.soundButtonKey))
        
        // MARK: - Biding
        isMainTimerCounting
            .flatMapLatest { isCounting in
                isCounting ? Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) : Observable.empty()
            }
            .map { _ in return 1 }
            .withLatestFrom(mainTimerCount) { plus, timer in
                return timer + plus
            }
            .bind(to: mainTimerCount)
            .disposed(by: disposeBag)
        
        isRestTimerCounting
            .flatMapLatest { isCounting in
                isCounting ? Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) : Observable.empty()
            }
            .map { _ in return 1 }
            .withLatestFrom(restTimerCount) { minus, timer in
                return timer - minus
            }
            .bind { if $0 >= 0 {
                self.restTimerCount.accept($0)
            } else {
                self.restTimerCountReset()
                self.playSoundOrVibrate()
            }
                }
            .disposed(by: disposeBag)
        
        isSoundOn
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance) // 빠르게 탭하면 UserDefault에 값을 제대로 저장 못 함.
            .bind {
                UserDefaults.standard.set($0, forKey: Identifier.soundButtonKey)
            }
            .disposed(by: disposeBag)
        
        resetCount
            .bind(to: restTimerCount)
            .disposed(by: disposeBag)
        
    }
    
    func changeSetVolume(at indexPath: IndexPath, to value: Double = 0.0, which type: SetVolumeChange) {
        Observable.just((indexPath, value))
            .withLatestFrom(workoutCellsRelay) { tuple, array in
                var willBeReturned = array
                let section = tuple.0.section
                let row = tuple.0.row
                let value = tuple.1
                switch type {
                case .reps: willBeReturned[section].sets[row - 1].reps = Int(value)
                case .weight: willBeReturned[section].sets[row - 1].weight = value
                case .checkBox: willBeReturned[section].sets[row - 1].check.toggle()
                }
                return willBeReturned
            }
            .bind(to: workoutCellsRelay)
            .disposed(by: disposeBag)
    }
    
    func workoutSectionCellData(_ indexPath: IndexPath) -> (String, Bool) {
        let sectionData = workoutCellsRelay.value[indexPath.section]
        return (sectionData.name, sectionData.isExpanded)
    }
    
    func workoutRowCellData(_ indexPath: IndexPath) -> (Int, SetVolume) {
        let setVolume = workoutCellsRelay.value[indexPath.section].sets[indexPath.row - 1]
        let index = indexPath.row
        return (index ,setVolume)
    }
    
    func applicationWillEnterForeground() {
        guard isMainTimerCounting.value == true else { return }
        let calender = Calendar.current
        let difference = calender.dateComponents([.second], from: didEnterBackgroundDate, to: Date())
        let seconds = difference.second ?? 0
        
        Observable.just(seconds)
            .withLatestFrom(mainTimerCount) { backgroundTime, previousCount in
                return backgroundTime + previousCount
            }
            .bind(to: mainTimerCount)
            .disposed(by: disposeBag)
    }
    
    func applicationDidEnterBackground() {
        guard isMainTimerCounting.value == true else { return }
        didEnterBackgroundDate = Date()
    }
    
    func expandSection(at indexPath: IndexPath) {
        Observable.just(indexPath)
            .withLatestFrom(workoutCellsRelay) { indexPath, cellDatas in
                var willBeReturned = cellDatas
                willBeReturned[indexPath.section].isExpanded.toggle()
                return willBeReturned
            }
            .bind(to: workoutCellsRelay)
            .disposed(by: disposeBag)
    }
    
    func swapElement(from: Int, to: Int) {
        Observable.just((from, to))
            .withLatestFrom(workoutCellsRelay) { indexTuple, cellDatas in
                var willBeReturned = cellDatas
                willBeReturned.swapAt(indexTuple.0, indexTuple.1)
                return willBeReturned
            }
            .bind(to: workoutCellsRelay)
            .disposed(by: disposeBag)
    }
    
    func checkButtonTapped(indexPath: IndexPath) {
        changeSetVolume(at: indexPath, which: .checkBox)
        let workout = workoutCellsRelay.value[indexPath.section]
        resetCount.accept(workout.rest)
        isRestTimerCounting.accept(workout.sets[indexPath.row - 1].check)
    }
    
    func restTimerCountChange(_ value: Int) {
        Observable.just(value)
            .withLatestFrom(restTimerCount) { value, count in
                return count + value
            }
            .bind(to: restTimerCount)
            .disposed(by: disposeBag)
    }
    
    func restTimerCountReset() {
        restTimerCount.accept(resetCount.value)
        isRestTimerCounting.accept(false)
    }
    
    func toggleBoolValue(_ relay: TogglableRelay) {
        switch relay {
        case .mainTimer:
            let toggle = !isMainTimerCounting.value
            isMainTimerCounting.accept(toggle)
        case .tableView:
            let toggle = !isEditingTableView.value
            if toggle == true { contractSections() } // true라면 먼저 축소시키고 -> edit 모드로 들어간다.
            isEditingTableView.accept(toggle)
        case .sound:
            let toggle = !isSoundOn.value
            isSoundOn.accept(toggle)
        }
    }
    
    func makeTimeTemplate(_ seconds: Int) -> String {
        let separatedTimes = secondsToHoursMinutesSeconds(seconds: seconds)
        return makeTimeString(hours: separatedTimes.0, minutes: separatedTimes.1, seconds: separatedTimes.2)
        
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
    
    private func contractSections() {
        Observable.just(true)
            .withLatestFrom(workoutCellsRelay) { _, cellDatas  in
                return cellDatas.map { WorkoutCellType($0) }
            }
            .bind(to: workoutCellsRelay)
            .disposed(by: disposeBag)
    }
    
    // TODO: 무음모드일 때는 들리지 않고 처음 사용자들은 놀랄 수도 있을 듯. 그냥 로컬 푸시 알림으로 대체하는 게 나을 것 같음.
    private func playSoundOrVibrate() {
        if isSoundOn.value {
            guard let soundURL = Bundle.main.url(forResource: "ES_Boxing Bell Ring 2 - SFX Producer", withExtension: "wav") else { return }
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        } else {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
    }
    
}

extension WorkoutViewModel {
    
    enum TogglableRelay {
        case mainTimer
        case tableView
        case sound
    }
    
    enum SetVolumeChange {
        case reps
        case weight
        case checkBox
    }
    
}
