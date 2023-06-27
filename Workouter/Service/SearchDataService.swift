//
//  SearchDataService.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/27.
//

import Foundation
import CoreData

final class SearchDataService {
    
    private let repository = SearchDataRepository.shared
    
    func fetchExercise() -> [Exercise] {
        let exerciseEntities: [SearchEntity] = repository.fetchSearchEntitiesFromCoreData()
        let programModels: [Exercise] = exerciseEntities.compactMap { Exercise(target: $0.bodyPart,
                                                                               name: $0.name,
                                                                               gifUrl: $0.gifURL,
                                                                               equipment: $0.equipment) }
        return programModels
    }
    
    func saveExercises(_ exercises: [Exercise]) {
        repository.saveExercises(exercises)
    }
    
}
