//
//  WorkoutViewModel.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/13.
//

import RxSwift
import RxRelay

struct WorkoutCellType {
    let name: String
    var sets: [SetVolume]
    var isExpanded: Bool
    
    init(_ workout: Workout){
        name = workout.name
        sets = workout.sets
        isExpanded = false
    }
}

final class WorkoutViewModel {
    
    let disposeBag = DisposeBag()
    
    let workoutCellsRelay: BehaviorRelay<[WorkoutCellType]>
    
    // MARK: - Timer
    let isMainTimerCounting = BehaviorRelay(value: true)
    let mainTimerCountEvent = BehaviorRelay(value: 1)
    lazy var mainTimerCount = mainTimerCountEvent.scan(0) { $0 + $1 }
    
    init(workouts: [Workout]) {
        let workoutCellTypes = workouts.map { WorkoutCellType($0) }
        workoutCellsRelay = BehaviorRelay(value: workoutCellTypes)
        
        isMainTimerCounting
            .asObservable()
            .flatMapLatest { isCounting in
                isCounting ? Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) : Observable.empty()
            }
            .map { _ in return 1 }
            .bind(to: mainTimerCountEvent)
            .disposed(by: disposeBag)
        
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
    
    func mainTimerStartAndStop() {
        let toggle = !isMainTimerCounting.value
        isMainTimerCounting.accept(toggle)
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
    
}
