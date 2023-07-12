//
//  APIRepository.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/11.
//

import Foundation
import RxSwift

// MARK: - 서버에서 데이터 Fetch 해오기

enum NetworkError: Error {
    case retryError
    case maxRequest
}

class NetworkService {
    
    private init() {}
    
    static func fetchWorkoutDataByTargetRx() -> Observable<[ExercisesResponseDTO]> {
        return Observable.create { emitter in
            let headers = [
                "X-RapidAPI-Key": "ebc2b996f3msh33acb2f28ee906fp1fe0a9jsn766591dae788",
                "X-RapidAPI-Host": "exercisedb.p.rapidapi.com"
            ]
            var request = URLRequest(url: URL(string: "https://exercisedb.p.rapidapi.com/exercises")!)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            let session = URLSession.shared
            let task = session.dataTask(with: request) { data, _, error in
                if error != nil {
                    emitter.onError(NetworkError.retryError)
                }
                if let data {
                    guard let entities = try? JSONDecoder().decode([ExercisesResponseDTO].self, from: data) else {

                        emitter.onError(NetworkError.maxRequest)
                        return }
                    emitter.onNext(entities)
                    emitter.onCompleted()
                }
                emitter.onCompleted()
            }
            task.resume()
            return Disposables.create()
        }
    }
}


