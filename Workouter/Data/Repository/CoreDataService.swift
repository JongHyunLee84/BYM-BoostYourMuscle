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
                var exercise = Exercise()
                if let target = Target(rawValue: $0.target ?? "chest") {
                    exercise = Exercise(target: target,
                                        name: $0.name ?? "",
                                        rest: Int($0.rest),
                                        id: Int($0.id),
                                        sets: $0.psetArray.compactMap { psetEntity in
                        let pset = SetVolume(reps: Int(psetEntity.reps),
                                        weight: psetEntity.weight,
                                        id: Int(psetEntity.id))
                        
                        return pset
                    }
                    )
                }
                exercise.sets.sort { $0.id < $1.id }
                return exercise
            }
            model.exercises.sort { $0.id < $1.id }
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
