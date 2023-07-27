//
//  WorkoutViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/04/05.
//

import RxRelay
import RxSwift

final class AddWorkoutViewModel {
    
    let disposeBag = DisposeBag()
    
    let workoutRelay = BehaviorRelay<Workout>(value: Workout())
    
    // MARK: - Workout properties
    let workoutNameRelay: BehaviorRelay<String>
    let restTimeRelay: BehaviorRelay<Int>
    let targetRelay: BehaviorRelay<Int>
    
    // MARK: - isSavable
    let isWorkoutSavable = BehaviorRelay(value: false)
    let isSetSavable = BehaviorRelay(value: false)
    
    // MARK: - SetVloume Properties
    let setsRelay: BehaviorRelay<[SetVolume]>
    let numberOfSetsRelay = BehaviorRelay(value: 0)
    let setsWeightRelay = BehaviorRelay(value: 0.0)
    let setsRepsRelay = BehaviorRelay(value: 0)
    
    // MARK: - Alerts and Message
    let alertTitle = "Missing Information"
    let addWorkoutMessage = "Please enter name and add at lease one set of this workout"
    let addSetVolumeMessage = "Please provide the weight and reps for this set."
    let emptyMessage = "How many sets are you going to do? 🤔"
    
        init(workout: Workout = Workout()) {
            // MARK: - init
            workoutNameRelay = BehaviorRelay<String>(value: workout.name)
            restTimeRelay = BehaviorRelay(value: workout.rest)
            targetRelay = BehaviorRelay(value: Target[workout.target])
            setsRelay = BehaviorRelay(value: workout.sets)
            
            // MARK: - Binding
            Observable.combineLatest(targetRelay, workoutNameRelay, restTimeRelay, setsRelay) { (targetRow, name, restTime, sets) -> Workout in
                Workout(target: Target.allCases[targetRow], name: name, rest: restTime, sets: sets)
            }
            .bind(to: workoutRelay)
            .disposed(by: disposeBag)
            
            Observable.combineLatest(setsWeightRelay, setsRepsRelay) {
                (weight, reps) -> Bool in
                return !weight.isZero && !reps.isZero
            }
            .bind(to: isSetSavable)
            .disposed(by: disposeBag)
            
            workoutRelay
                .map { $0.sets.count }
                .bind(to: numberOfSetsRelay)
                .disposed(by: disposeBag)
            
            workoutRelay
                .map { !$0.name.isEmpty && !$0.sets.count.isZero }
                .bind(to: isWorkoutSavable)
                .disposed(by: disposeBag)
    
        }
    
    func changeRestTime(_ tag: Int) {
        let value = (tag == 0) ? -10 : 10
        Observable.just(value)
            .withLatestFrom(restTimeRelay) { (value, now) -> Int in
                max(0, now + value)
            }
            .bind(to: restTimeRelay)
            .disposed(by: disposeBag)
    }
    
    func addSetVolume() {
        Observable.combineLatest(setsWeightRelay, setsRepsRelay) { (weight, reps) -> SetVolume in
            let sets = SetVolume(reps: reps, weight: weight)
            return sets
        }
        .withLatestFrom(setsRelay) { (new, array) in
            var willBeReturned = array
            willBeReturned.append(new)
            return willBeReturned
        }
        .take(1)
        .bind(to: setsRelay)
        .disposed(by: disposeBag)
    }
    
    func removeSetVolumeAt(_ index: Int) {
        Observable.just(index)
            .withLatestFrom(setsRelay) { idx, array in
                var willBeReturned = array
                willBeReturned.remove(at: idx)
                return willBeReturned
            }
            .bind(to: setsRelay)
            .disposed(by: disposeBag)
    }
}
    

//expadable View를 위한 bool 타입 속성
//var isOpened: Bool = false
//    var target: Target {
//        return exerciseRelay.target
//    }
//    var name: String {
//        return exerciseRelay.name
//    }
//    var rest: Int {
//        return exerciseRelay.rest
//    }
//    var sets: [SetVolumeViewModel] {
//        return setsVM
//    }
//
//

    
    //    convenience init() {
    //        self.init(exercise: Exercise())
    //    }
    
//    func returnName() -> String {
//        return exerciseRelay.name
//    }
//
//    func returnTotalVolume() -> Double {
//        return exerciseRelay.totalVolume
//    }
//
//    func returnTarget() -> String {
//        return exerciseRelay.target.rawValue
//    }
//
//    func returnSets() -> String {
//        return "\(self.setsVM.count) set"
//    }
//
//    func returnRest() -> Int {
//        return exerciseRelay.rest
//    }
//
//    func returnPsetAt(_ index: Int) -> (SetVolumeViewModel, Int) {
//        return (setsVM[index], index+1)
//    }
//
//
//
//
//
//    func saveName(_ name: String) {
//        self.exerciseRelay.name = name
//    }
//
//    func saveRest(_ rest: String) {
//        guard let rest = Int(rest) else { return }
//        self.exerciseRelay.rest = rest
//    }
//

//}


//func saveTarget(_ row: Int) {
//    self.exerciseRelay.target = Target.allCases[row]
//}
//    var numberOfSets: Int {
//        return exerciseRelay.sets.count
//    }
//    private var setsVM: [SetVolumeViewModel] {
//        didSet {
//            exerciseRelay.sets = setsVM.map {
//                SetVolume(reps: $0.reps,
//                     weight: $0.weight)
//
//            }
//        }
//    }
