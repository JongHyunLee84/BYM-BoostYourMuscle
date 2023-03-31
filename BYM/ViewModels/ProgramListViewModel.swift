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
    
    private var program: Program
    
    init(program: Program) {
        self.program = program
    }
    
    func returnTitle() -> String {
        return program.title
    }
    
    func returnExercises() -> [ExerciseViewModel] {
        let exerciseListVM = program.exercises.map {ExerciseViewModel(exercise: $0)}
        return exerciseListVM
    }

}

class ExerciseViewModel {
    private var exercise: Exercise
    
    //expadable View를 위한 bool 타입 속성
    var isOpened: Bool = false
    
    init(exercise: Exercise) {
        self.exercise = exercise
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
        return exercise.sets.map { PSetViewModel(pset: $0) }
    }
    
}

class PSetViewModel {
    private var pset: PSet
    
    init(pset: PSet) {
        self.pset = pset
    }
    func returnWeight() -> String {
        return String(pset.weight)
    }
    func returnReps() -> String {
        return String(pset.reps)
    }
    func returnCheck() -> Bool {
        return pset.check
    }
    
}

