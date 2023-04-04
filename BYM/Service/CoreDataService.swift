//
//  CoreDataService.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//

import Foundation

final class CoreDataService {
    
    private let repository = CoreDataRepository.shared
    
    func fetchProgram() -> [Program] {
        let programEntities: [ProgramEntity] = repository.fetchProgramFromCoreData()
        let programModels: [Program] = programEntities.compactMap { entity in
            var model: Program = Program(exercises: [], title: "")
            model.title = entity.title ?? ""
            model.exercises = entity.exerciseArray.compactMap {
                var exercise = Exercise(target: .back, name: "", sets: [])
                if let target = Target(rawValue: $0.target ?? "chest") {
                    exercise = Exercise(target: target,
                                        name: $0.name ?? "",
                                        sets: $0.psetArray.compactMap {
                        let pset = PSet(reps: Int($0.reps),
                                        weight: $0.weight)
                        return pset
                    }
                    )
                }
                return exercise
            }
            
            return model
        }
        return programModels
    }
    
    func deleteProgram(_ program: Program) {
        repository.deleteProgram(program)
    }
    
    func saveProgram(_ program: Program) {
        repository.saveProgram(program)
    }
    
}
