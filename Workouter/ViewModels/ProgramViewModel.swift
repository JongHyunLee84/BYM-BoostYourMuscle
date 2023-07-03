//
//  ProgramViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/04/05.
//

import Foundation

final class ProgramViewModel {
    private let cdService = CoreDataService()
    var program: Program
    var exercisesVM: [ExerciseViewModel] {
        didSet {
            program.exercises = exercisesVM.map {
                let exercise = Exercise(target: $0.target,
                                        name: $0.name,
                                        rest: $0.rest,
                                        sets: $0.sets.map {
                    let pset = SetVolume(reps: $0.reps,
                                    weight: $0.weight)
                    return pset
                })
                return exercise
            }
        }
    }
    
    var numberOfExercise: Int {
        exercisesVM.count
    }
    
    init(program: Program) {
        self.program = program
        exercisesVM = program.exercises.map { ExerciseViewModel(exercise: $0) }
    }

    convenience init() {
        let program = Program(exercises: [], title: "")
        self.init(program: program)
    }
    
    var title: String {
        return program.title
    }
    
    // 참조 x 새로운 값으로 넘김
    func returnExercises() -> [ExerciseViewModel] {
        return program.exercises.map { ExerciseViewModel(exercise: $0) }
    }
    
    func addExercise(_ vm: ExerciseViewModel) {
        exercisesVM.append(vm)
    }
    
    func setName(_ name: String) {
        program.title = name
    }
    
    func saveProgram() {
        cdService.saveProgram(self.program)
    }
    
    func removeExerciseAt(_ index: Int) {
        exercisesVM.remove(at: index)
    }
    
    
}
