//
//  ExerciseViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/04/05.
//

import Foundation

final class ExerciseViewModel {
    var exercise: Exercise
    private var setsVM: [PSetViewModel] {
        didSet {
            exercise.sets = setsVM.map {
                PSet(reps: $0.reps,
                     weight: $0.weight)
                
            }
        }
    }
    //expadable View를 위한 bool 타입 속성
    var isOpened: Bool = false
    var target: Target {
        return exercise.target
    }
    var name: String {
        return exercise.name
    }
    var rest: Int {
        return exercise.rest
    }
    var sets: [PSetViewModel] {
        return setsVM
    }
    
    var numberOfSets: Int {
        return exercise.sets.count
    }
    init(exercise: Exercise) {
        self.exercise = exercise
        setsVM = exercise.sets.compactMap{ PSetViewModel(pset: $0) }
    }
    
    convenience init() {
        self.init(exercise: Exercise())
    }
    
    func returnName() -> String {
        return exercise.name
    }
    
    func returnTotalVolume() -> Double {
        return exercise.totalVolume
    }
    
    func returnTarget() -> String {
        return exercise.target.rawValue
    }
    
    func returnSets() -> String {
        return "\(self.setsVM.count) set"
    }
    
    func returnRest() -> Int {
        return exercise.rest
    }
    
    func returnPsetAt(_ index: Int) -> PSetViewModel {
        return setsVM[index]
    }
    
    func changeRestTime(_ tag: Int) -> String {
        if tag.isZero {
            if (exercise.rest-10) <= 0 {
                exercise.rest = 0
            } else {
                exercise.rest -= 10
            }
        } else {
            exercise.rest += 10
        }
        return String(exercise.rest)
    }
    
    func saveTarget(_ row: Int) {
        self.exercise.target = Target.allCases[row]
    }
    
    func saveName(_ name: String) {
        self.exercise.name = name
    }
    
    func saveRest(_ rest: String) {
        guard let rest = Int(rest) else { return }
        self.exercise.rest = rest
    }
    
    func addPSet(weight: String?, reps: String?) {
        guard let psetVM = PSetViewModel(weight: weight ?? "", reps: reps ?? "") else { print("returned nil"); return }
        setsVM.append(psetVM)
    }
    
    func removePsetAt(_ index: Int) {
        setsVM.remove(at: index)
    }
}
