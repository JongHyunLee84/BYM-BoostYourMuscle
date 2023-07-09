//
//  ProgramViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/04/05.
//

import RxSwift
import RxRelay

final class ProgramViewModel {
    
    private let programsRepository: ProgramsRepository = DefaultProgramsRepository(storage: CoreDataProgramStorage())
    
    let disposeBag = DisposeBag()
    
    let programRelay = BehaviorRelay<Program>(value: Program())
    let titleRelay = BehaviorRelay<String>(value: "")
    let exercisesRelay = BehaviorRelay<[Exercise]>(value: [])
    let numberOfExercises = BehaviorRelay<Int>(value: 0)
    let isSavable = BehaviorRelay(value: false)
    let emptyMessage = "Please add workouts of your program! 🏋️"
    let saveAlert = (title: "SAVE", message: "Would you like to save this program?")
    let rejectAlert = (title: "Missing Information", message: "Program should have name \n and at least one workout")
    var exercise = Exercise()
    init() {
        
        exercisesRelay
            .map { $0.count }
            .bind(to: numberOfExercises)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(titleRelay, exercisesRelay)
            .map { (title, exercises) -> Program in
                Program(exercises: exercises, title: title)
            }
            .bind(to: programRelay)
            .disposed(by: disposeBag)
        
        programRelay
            .map { program -> Bool in
                !program.title.isEmpty && !program.exercises.isEmpty
            }
            .bind(to: isSavable)
            .disposed(by: disposeBag)
    }
    
    // 참조 x 새로운 값으로 넘김
//    func returnExercises() -> [ExerciseViewModel] {
//        return programRelay.exercises.map { ExerciseViewModel(exercise: $0) }
//    }

    func addExercise(_ exercise: Exercise) {
        Observable<Exercise>
            .just(exercise)
            .withLatestFrom(exercisesRelay) { (new, array) -> [Exercise] in
                var willBeReturned = array
                willBeReturned.append(new)
                return willBeReturned
            }
            .take(1)
            .bind(to: exercisesRelay)
            .disposed(by: disposeBag)
    }
    
//    func saveProgram() {
//        programRelay
//            .take(1)
//            .bind {
//                self.programsRepository.saveProgram($0)
//            }
//            .disposed(by: disposeBag)
//    }
    
    func removeExerciseAt(_ index: Int) {
        Observable<Int>
            .just(index)
            .withLatestFrom(exercisesRelay) { (idx, array) -> [Exercise] in
                var willBeReturned = array
                willBeReturned.remove(at: idx)
                return willBeReturned
            }
            .take(1)
            .bind(to: exercisesRelay)
            .disposed(by: disposeBag)
    }
    
    
}
