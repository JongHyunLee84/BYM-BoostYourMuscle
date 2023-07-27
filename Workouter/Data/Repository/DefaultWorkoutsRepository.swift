//
//  APIService.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/11.
//

import RxSwift

// MARK: - Fetch한 데이터를 앱에서 사용할 모델로 매핑
class DefaultWorkoutsRepository: WorkoutsRepository {
    
    func fetchWorkouts() -> Observable<[Workout]> {
        return Observable.create { emitter in
            NetworkService.fetchWorkoutDataByTargetRx()
                .map { entities in
                    return entities.compactMap { Workout(target: $0.bodyPart,
                                                          name: $0.name.capitalized,
                                                          gifUrl: $0.gifURL,
                                                          equipment: $0.equipment)}}
                .subscribe { workouts in
                    emitter.onNext(workouts)
                    emitter.onCompleted()
                } onError: { error in
                    emitter.onError(error)
                }
        }
        
    }
    
    func saveWorkout(_ workout: Workout) { print("not needed yet") }
    func deleteWorkout(_ workout: Workout) { print("not needed yet") }
    func updateWorkout(_ workout: Workout) { print("not needed yet") }
}

