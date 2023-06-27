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
    
    let workoutsRelay = BehaviorRelay<[Exercise]>(value: [])
    let bodyPartRelay = BehaviorRelay<[Exercise]>(value: [])
    let bodyPartStr = BehaviorSubject(value: "all")
    let workoutErrorSubject = PublishSubject<Error>()
    let apiService = APIService()
    let searchDataService = SearchDataService()
    // AddWorkoutView에 보낼 exercise
    var exercise: Exercise?
    private let disposeBag = DisposeBag()
    
    init() {
        let exercise = searchDataService.fetchExercise()
        if exercise.isEmpty {
            apiService.fetchWorkouts()
                .subscribe(on: MainScheduler.instance)
                .subscribe { [weak self] exerciseList in
                    self?.workoutsRelay.accept(exerciseList)
                    self?.searchDataService.saveExercises(exerciseList)
                } onError: { [weak self] error in
                    guard let self else { return }
                    self.workoutErrorSubject.onNext(error)
                }
                .disposed(by: disposeBag)
        } else {
            workoutsRelay.accept(exercise)
        }
        
        bodyPartStr
            .flatMapLatest { [weak self] query -> Observable<[Exercise]> in
                guard let self = self else { return .empty() }
                let lowercaseQuery = query.replacingOccurrences(of: " ", with: "%20").lowercased()
                return self.workoutsRelay
                    .map { workouts -> [Exercise] in
                        if lowercaseQuery == "all" {
                            return workouts
                        } else {
                            return workouts.filter { exercise in
                                let containsQuery = exercise.equipment?.localizedCaseInsensitiveContains(lowercaseQuery) ?? false ||
                                exercise.name.localizedCaseInsensitiveContains(lowercaseQuery) ||
                                exercise.target.rawValue.localizedCaseInsensitiveContains(lowercaseQuery)
                                return containsQuery
                            }
                        }
                    }
            }
            .bind(to: bodyPartRelay)
            .disposed(by: disposeBag)
    }
    
}
