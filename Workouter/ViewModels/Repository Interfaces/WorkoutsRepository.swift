//
//  WorkoutsRepository.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/04.
//

import RxSwift

protocol WorkoutsRepository {
    func saveWorkout(_ workout: Workout)
    func fetchWorkouts() -> Observable<[Workout]>
    func deleteWorkout(_ workout: Workout)
    func updateWorkout(_ workout: Workout)
}
