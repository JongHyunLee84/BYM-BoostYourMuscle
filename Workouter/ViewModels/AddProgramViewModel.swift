//
//  ProgramViewModel.swift
//  BYM
//
//  Created by 이종현 on 2023/04/05.
//

import RxRelay
import RxSwift

final class AddProgramViewModel {
    
    private let programsRepository: ProgramsRepository = DefaultProgramsRepository(storage: CoreDataProgramStorage())
    
    let disposeBag = DisposeBag()
    
    let programRelay = BehaviorRelay<Program>(value: Program())
    let titleRelay = BehaviorRelay<String>(value: "")
    let workoutListRelay = BehaviorRelay<[Workout]>(value: [])
    let numberOfWorkouts = BehaviorRelay<Int>(value: 0)
    let isSavable = BehaviorRelay(value: false)
    let workoutRelay = BehaviorRelay(value: Workout())
    let emptyMessage = "Please add workouts of your program! 🏋️"
    let saveAlert = (title: "SAVE", message: "Would you like to save this program?")
    let rejectAlert = (title: "Missing Information", message: "Program should have name \n and at least one workout")
    
    init() {
        
        workoutListRelay
            .map { $0.count }
            .bind(to: numberOfWorkouts)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(titleRelay, workoutListRelay)
            .map { (title, workouts) -> Program in
                Program(workouts: workouts, title: title)
            }
            .bind(to: programRelay)
            .disposed(by: disposeBag)
        
        programRelay
            .map { program -> Bool in
                !program.title.isEmpty && !program.workouts.isEmpty
            }
            .bind(to: isSavable)
            .disposed(by: disposeBag)
    }
    
    // 참조 x 새로운 값으로 넘김
//    func returnExercises() -> [ExerciseViewModel] {
//        return programRelay.exercises.map { ExerciseViewModel(exercise: $0) }
//    }

    func addWorkout(_ workout: [Workout]) {
        Observable<[Workout]>
            .just(workout)
            .withLatestFrom(workoutListRelay) { (new, array) -> [Workout] in
                var willBeReturned = array
                willBeReturned += new
                return willBeReturned
            }
            .bind(to: workoutListRelay)
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
    
    func removeWorkoutAt(_ index: Int) {
        Observable<Int>
            .just(index)
            .withLatestFrom(workoutListRelay) { (idx, array) -> [Workout] in
                var willBeReturned = array
                willBeReturned.remove(at: idx)
                return willBeReturned
            }
            .bind(to: workoutListRelay)
            .disposed(by: disposeBag)
    }
    
    
}
