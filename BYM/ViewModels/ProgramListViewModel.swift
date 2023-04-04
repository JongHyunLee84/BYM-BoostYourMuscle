//
//  ProgramListTableViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/03/29.
//

import Foundation

final class ProgramListViewModel {
    
    private let service = CoreDataService()
    private var programList: [ProgramViewModel] = []
    
    init() {
        let programViewModels = service.fetchProgram().compactMap { program in
            ProgramViewModel(program: program)
        }
        self.programList = programViewModels
    }
    
    func addProgram(_ vm: ProgramViewModel) {
        programList.append(vm)
        service.saveProgram(Program(exercises: vm.program.exercises,
                                    title: vm.title))
    }
    
    func numberOfRows() -> Int {
        self.programList.count
    }
    
    func returnViewModelAt(_ index: Int) -> ProgramViewModel {
        return programList[index]
    }
}

final class ProgramViewModel {
    
    fileprivate var program: Program
    private var excercisesVM: [ExerciseViewModel]
    init(program: Program) {
        self.program = program
        excercisesVM = program.exercises.map { ExerciseViewModel(exercise: $0) }
    }
    
    var title: String {
        return program.title
    }
    
    var exercises: [ExerciseViewModel] {
        return self.excercisesVM
    }

}

final class ExerciseViewModel {
    private var exercise: Exercise
    private var setsVM: [PSetViewModel]
    //expadable View를 위한 bool 타입 속성
    var isOpened: Bool = false
    
    init(exercise: Exercise) {
        self.exercise = exercise
        setsVM = exercise.sets.compactMap{ PSetViewModel(pset: $0) }
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

final class PSetViewModel {
    static var creatNumber = 1
    
    private var pset: PSet
    // 뷰에 몇 번째 세트인지 보여주기 위함.
    var setNumber: String {
        return String(Self.creatNumber)
    }
    init(pset: PSet) {
        self.pset = pset
        Self.creatNumber += 1
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

