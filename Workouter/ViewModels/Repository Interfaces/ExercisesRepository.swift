//
//  ExercisesRepository.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/04.
//

import RxSwift

protocol ExercisesRepository {
    func saveExercise(_ exercise: Exercise)
    func fetchExercises() -> Observable<[Exercise]>
    func deleteExercise(_ exercise: Exercise)
    func updateExercise(_ exercise: Exercise)
}
