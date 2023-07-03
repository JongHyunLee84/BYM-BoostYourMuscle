//
//  APIService.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/11.
//

import Foundation
import RxSwift
// MARK: - Fetch한 데이터를 앱에서 사용할 모델로 매핑

class APIService {
    // MARK: - 당장 필요한 셀만 매핑하는 방식
    func fetchWorkouts() -> Observable<[Exercise]> {
        return Observable.create { emitter in
            APIRepository.fetchWorkoutDataByTargetRx()
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
    
//    func fetchMocks() -> Observable<[Exercise]> {
//        return Observable.create { emitter in
//            let benches = Array(repeating: Exercise(target: "chest", name: "bench Press", gifUrl: "https://gymvisual.com/img/p/1/7/5/5/2/17552.gif", equipment: "barbell")!, count: 10)
//            emitter.onNext(benches)
//            let pullUps = Array(repeating: Exercise(target: "back", name: "pull ups", gifUrl: "https://gymvisual.com/img/p/5/3/8/6/5386.gif", equipment: "barbell")!, count: 10)
//            emitter.onNext(pullUps)
//            return Disposables.create()
//        }
//    }
}

