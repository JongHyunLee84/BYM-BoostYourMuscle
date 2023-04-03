//
//  ProgramListTableViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import Foundation

class ProgramListViewModel {
    private var programList: [ProgramViewModel] = []
    
    func addProgram(_ vm: ProgramViewModel) {
        programList.append(vm)
    }
    
    func numberOfRows() -> Int {
        self.programList.count
    }
    
    func modelAt(_ index: Int) -> ProgramViewModel {
        return programList[index]
    }
}

class ProgramViewModel {
    
    private var program: Programs
    private var excercisesVM: [ExerciseViewModel]
    init(program: Programs) {
        self.program = program
        excercisesVM = program.exercises.map { ExerciseViewModel(exercise: $0) }
    }
    
    func returnTitle() -> String {
        return program.title
    }
    
    func returnExercises() -> [ExerciseViewModel] {
        return self.excercisesVM
    }

}

class ExerciseViewModel {
    private var exercise: Exercises
    private var setsVM: [PSetViewModel]
    //expadable View를 위한 bool 타입 속성
    var isOpened: Bool = false
    
    init(exercise: Exercises) {
        self.exercise = exercise
        setsVM = exercise.sets.map{ PSetViewModel(pset: $0) }
    }
    
    func returnName() -> String {
        return exercise.name
    }
    
    func returnTotalVolume() -> Double {
        return exercise.totalVolume
    }
    
    func returnTarget() -> Target {
        return exercise.target
    }
    
    func returnSets() -> [PSetViewModel] {
        return self.setsVM
    }
    
    func returnRest() -> Int {
        return exercise.rest
    }
    
}

class PSetViewModel {
    private var pset: PSets
    
    init(pset: PSets) {
        self.pset = pset
    }
    func returnWeight() -> String {
        // 소수점이 있는지 여부 % 쓰려니까 이제 못 쓰게함
        if pset.weight.truncatingRemainder(dividingBy: 1) == 0 {
            let rounded = Int(pset.weight)
            return "\(rounded)"
        }
        return "\(pset.weight)"
    }
    func returnReps() -> String {
        return "\(pset.reps)"
    }
    func returnCheck() -> Bool {
        return pset.check
    }
    
    func toggleCheck() {
        pset.check.toggle()
    }
    
}

