//
//  TestViewmodel.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/11.
//

import RxRelay
import RxSwift

class SearchViewModel {
    
    // MARK: - Rx
    let totalWorkouts = BehaviorRelay<[Workout]>(value: [])
    let filteredWorkouts = BehaviorRelay<[Workout]>(value: [])
    let searchBarStr = PublishRelay<String>()
    let bodyPartStr = BehaviorRelay(value: "all")
    let workoutErrorSubject = PublishSubject<Error>()
    let addedWorkoutList = BehaviorRelay<[Workout]>(value: [])
    
    var workoutsRepository: WorkoutsRepository
    
    let errorTitle = "Data Upgrade in Progress"
    let errorMessage = "We apologize for the inconvenience,\n but we are currently upgrading the workout data.\n We are unable to provide the data at the moment.\n We will update it as soon as possible."
    
    private let disposeBag = DisposeBag()
    
    init(repository: WorkoutsRepository = DefaultWorkoutsRepository()) {
        // MARK: - init
        workoutsRepository = repository
        
        // MARK: - Rx
        workoutsRepository.fetchWorkouts()
                .subscribe { [weak self] workoutList in
                    self?.totalWorkouts.accept(workoutList)
                } onError: { [weak self] error in
                    guard let self else { return }
                    self.workoutErrorSubject.onNext(error)
                }
                .disposed(by: disposeBag)


        bodyPartStr
            .flatMap { [weak self] query -> Observable<[Workout]> in
                guard let self = self else { return .empty() }
                let lowercaseQuery = query
                return self.totalWorkouts
                    .map { workouts -> [Workout] in
                        if lowercaseQuery.localizedCaseInsensitiveContains("all") {
                            return workouts
                        } else {
                            return workouts.filter { $0.target.rawValue.localizedCaseInsensitiveContains(lowercaseQuery) }
                        }
                    }
            }
            .bind(to: filteredWorkouts)
            .disposed(by: disposeBag)
        
        searchBarStr
            .subscribe(onNext: { [weak self] query in
                guard let self = self else { return }
                let lowercaseQuery = query.replacingOccurrences(of: " ", with: "")
                let filtered = self.totalWorkouts.value.filter { original in
                    var workout = original
                    workout.name = original.name.replacingOccurrences(of: " ", with: "")
                    workout.equipment = original.equipment?.replacingOccurrences(of: " ", with: "") ?? ""
                    if lowercaseQuery == "" {
                        if self.bodyPartStr.value.localizedCaseInsensitiveContains("all") {
                            return true
                        }
                        return workout.target.rawValue == self.bodyPartStr.value.lowercased()
                    } else {
                        if self.bodyPartStr.value.localizedCaseInsensitiveContains("all") {
                            let containsQuery = workout.equipment?.localizedCaseInsensitiveContains(lowercaseQuery) ?? false ||
                                workout.name.localizedCaseInsensitiveContains(lowercaseQuery) ||
                            workout.target.rawValue.localizedCaseInsensitiveContains(lowercaseQuery)
                            return containsQuery
                        } else {
                            let containsQuery = (workout.equipment?.localizedCaseInsensitiveContains(lowercaseQuery) ?? false ||
                                workout.name.localizedCaseInsensitiveContains(lowercaseQuery)) &&
                            workout.target.rawValue == self.bodyPartStr.value.lowercased()
                            return containsQuery
                        }
                    }
                }
                filteredWorkouts.accept(filtered)
            })
            .disposed(by: disposeBag)
    }
    
    func targetButtonTapped(title: String?) {
        bodyPartStr.accept(title ?? "all")
    }
    
    func workoutAdded(_ workout: Workout) {
        Observable.just(workout)
            .withLatestFrom(addedWorkoutList) { workout, list in
                var willReturned = list
                willReturned.append(workout)
                return willReturned
            }
            .bind(to: addedWorkoutList)
            .disposed(by: disposeBag)
    }
    
}
