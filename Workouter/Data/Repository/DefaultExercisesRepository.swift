//
//  APIService.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/11.
//

import Foundation
import RxSwift
// MARK: - Fetch한 데이터를 앱에서 사용할 모델로 매핑

class DefaultExercisesRepository: ExercisesRepository {
    // MARK: - 당장 필요한 셀만 매핑하는 방식
    func fetchExercises() -> Observable<[Exercise]> {
        return Observable.create { emitter in
            NetworkService.fetchWorkoutDataByTargetRx()
                .map { entities in
                    return entities.compactMap { Exercise(target: $0.bodyPart,
                                                          name: $0.name.capitalized,
                                                          gifUrl: $0.gifURL,
                                                          equipment: $0.equipment)}}
                .subscribe { exercises in
                    emitter.onNext(exercises)
                    emitter.onCompleted()
                } onError: { error in
                    emitter.onError(error)
                }
        }
        
    }
    
    func saveExercise(_ exercise: Exercise) { print("not needed yet") }
    func deleteExercise(_ exercise: Exercise) { print("not needed yet") }
    func updateExercise(_ exercise: Exercise) { print("not needed yet") }
}

