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
    
    var workoutsRelay = BehaviorRelay<[Exercise]>(value: [])
    let apiService = APIService()
    
    // AddWorkoutView에 보낼 exercise
    var exercise: Exercise?
    
    init(_ target: String) {
        changeExercise("chest")
    }
    
    func changeExercise(_ target: String) {
        let str = target.replacingOccurrences(of: " ", with: "%20").lowercased()
        workoutsRelay.accept([])
        let _ = apiService.fetchWorkouts(str)
            .take(1)
            .bind(to: workoutsRelay)
    }
    
    
}
