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
    
    let programRelay = BehaviorRelay(value: Program())
    let numberOfExercise = BehaviorRelay(value: 0)
    var exercise = Exercise()
    
   
    
    // 참조 x 새로운 값으로 넘김
//    func returnExercises() -> [ExerciseViewModel] {
//        return programRelay.exercises.map { ExerciseViewModel(exercise: $0) }
//    }

    func addExercise(_ exercise: Exercise) {
        Observable<Exercise>
            .just(exercise)
            .withLatestFrom(programRelay) { (new, program) -> Program in
                var willBeReturned = program
                willBeReturned.exercises.append(new)
                return willBeReturned
            }
            .take(1)
            .bind(to: programRelay)
            .disposed(by: disposeBag)
    }
    
    func setName(_ name: String) {
//        programRelay.title = name
        
    }
    
    func saveProgram() {
//        programsRepository.saveProgram(self.programRelay)
    }
    
    func removeExerciseAt(_ index: Int) {
//        programRelay.exercises.remove(at: index)
    }
    
    
}
