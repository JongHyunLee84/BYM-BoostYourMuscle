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
    func fetchWorkouts(_ target: String) -> Observable<[Exercise]> {
        return APIRepository.fetchWorkoutDataByTargetRx(target)
            .map { entities in
                return entities.map {
                    return Exercise(target: Target(rawValue: $0.bodyPart) ?? .chest,
                                    name: $0.name.capitalized,
                                    gifUrl: $0.gifURL,
                                    equipment: $0.equipment)}
            }
    }
    
    // MARK: - 모든 element를 gif로 매핑하고 셀 로딩하는 방식
//    func fetchWorkouts(_ target: String) -> Observable<[Exercise]> {
//        let scheduler = ConcurrentDispatchQueueScheduler(qos: .userInteractive)
//        return APIRepository.fetchWorkoutDataByTargetRx(target)
//            .flatMap { entities in
//                return Observable.just(entities)
//                    .observe(on: scheduler)
//                    .map { entity in
//                        print(Thread.current)
//                        return Exercise(target: Target(rawValue: entity.bodyPart)!,
//                                        name: entity.name,
//                                        gif: UIImage.gifImageWithURL(entity.gifURL),
//                                        equipment: entity.equipment)
//                    }
//                    .toArray()
//                    .asObservable()
//            }
//    }
    
}
