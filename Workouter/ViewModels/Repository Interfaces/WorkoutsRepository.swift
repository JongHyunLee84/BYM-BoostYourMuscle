//
//  ExercisesRepository.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/04.
//

import RxSwift

protocol WorkoutsRepository {
    func saveWorkout(_ exercise: Workout)
    func fetchWorkouts() -> Observable<[Workout]>
    func deleteWorkout(_ exercise: Workout)
    func updateWorkout(_ exercise: Workout)
}
