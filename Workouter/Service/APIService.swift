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
    func fetchWorkouts(_ target: String) -> Observable<[Exercise]> {
        return APIRepository.fetchWorkoutDataByTargetRx(target)
            .map { entities in
                return entities.map { Exercise(target: Target(rawValue: $0.bodyPart)!,
                                               name: $0.name.capitalized,
                                               gifUrl: $0.gifURL,
                                               equipment: $0.equipment)}
            }
    }

}
