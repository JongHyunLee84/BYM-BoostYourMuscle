//
//  TestViewmodel.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/11.
//

import Foundation
import RxSwift
import RxRelay
class SearchViewModel {
    
    // MARK: - Rx
    let totalExercises = BehaviorRelay<[Exercise]>(value: [])
    let filteredExercises = BehaviorRelay<[Exercise]>(value: [])
    let searchBarStr = PublishRelay<String>()
    let bodyPartStr = BehaviorRelay(value: "all")
    let workoutErrorSubject = PublishSubject<Error>()
    let addedExercisesList = BehaviorRelay<[Exercise]>(value: [])
    
    var exercisesRepository: ExercisesRepository
    
    let errorTitle = "Data Upgrade in Progress"
    let errorMessage = "We apologize for the inconvenience,\n but we are currently upgrading the exercise data.\n We are unable to provide the data at the moment.\n We will update it as soon as possible."
    
    private let disposeBag = DisposeBag()
    
    init(repository: ExercisesRepository = DefaultExercisesRepository()) {
        // MARK: - init
        exercisesRepository = repository
        
        // MARK: - Rx
        exercisesRepository.fetchExercises()
                .subscribe { [weak self] exerciseList in
                    self?.totalExercises.accept(exerciseList)
                } onError: { [weak self] error in
                    guard let self else { return }
                    self.workoutErrorSubject.onNext(error)
                }
                .disposed(by: disposeBag)


        bodyPartStr
            .flatMap { [weak self] query -> Observable<[Exercise]> in
                guard let self = self else { return .empty() }
                let lowercaseQuery = query
                return self.totalExercises
                    .map { workouts -> [Exercise] in
                        if lowercaseQuery.localizedCaseInsensitiveContains("all") {
                            return workouts
                        } else {
                            return workouts.filter { $0.target.rawValue.localizedCaseInsensitiveContains(lowercaseQuery) }
                        }
                    }
            }
            .bind(to: filteredExercises)
            .disposed(by: disposeBag)
        
        searchBarStr
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                let lowercaseQuery = query.replacingOccurrences(of: " ", with: "")
                let filtered = self.totalExercises.value.filter { original in
                    var exercise = original
                    exercise.name = original.name.replacingOccurrences(of: " ", with: "")
                    exercise.equipment = original.equipment?.replacingOccurrences(of: " ", with: "") ?? ""
                    if lowercaseQuery == "" {
                        if self.bodyPartStr.value.localizedCaseInsensitiveContains("all") {
                            return true
                        }
                        return exercise.target.rawValue == self.bodyPartStr.value.lowercased()
                    } else {
                        if self.bodyPartStr.value.localizedCaseInsensitiveContains("all") {
                            let containsQuery = exercise.equipment?.localizedCaseInsensitiveContains(lowercaseQuery) ?? false ||
                                exercise.name.localizedCaseInsensitiveContains(lowercaseQuery) ||
                            exercise.target.rawValue.localizedCaseInsensitiveContains(lowercaseQuery)
                            return containsQuery
                        } else {
                            let containsQuery = (exercise.equipment?.localizedCaseInsensitiveContains(lowercaseQuery) ?? false ||
                                exercise.name.localizedCaseInsensitiveContains(lowercaseQuery)) &&
                            exercise.target.rawValue == self.bodyPartStr.value.lowercased()
                            return containsQuery
                        }
                    }
                }
                filteredExercises.accept(filtered)
            })
            .disposed(by: disposeBag)
    }
    
    func targetButtonTapped(title: String?) {
        bodyPartStr.accept(title ?? "all")
    }
    
    func exerciseAdded(_ exercise: Exercise) {
        Observable.just(exercise)
            .withLatestFrom(addedExercisesList) { exercise, list in
                var willReturned = list
                willReturned.append(exercise)
                return list
            }
            .bind(to: addedExercisesList)
            .disposed(by: disposeBag)
    }
    
}
