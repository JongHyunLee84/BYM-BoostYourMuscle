//
//  CoreDataService.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//

import RxSwift

final class DefaultProgramsRepository {
    
    private let storage: CoreDataProgramStorage
    
    init(storage: CoreDataProgramStorage) {
        self.storage = storage
    }
    
}

extension DefaultProgramsRepository: ProgramsRepository {
    
    func saveProgram(_ program: Program) {
        storage.saveProgramEntity(program)
    }
    
    func fetchPrograms() -> Observable<[Program]> {
        return Observable.create { emmiter in
            self.storage.fetchProgramEntities { programEntities in
                
                let programModels: [Program] = programEntities.compactMap { entity in
                    var model: Program = Program(workouts: [], title: "")
                    model.title = entity.title ?? ""
                    model.workouts = entity.exerciseArray.compactMap {
                        var workout = Workout()
                        if let target = Target(rawValue: $0.target ?? "chest") {
                            workout = Workout(target: target,
                                                name: $0.name ?? "",
                                                rest: Int($0.rest),
                                                id: Int($0.id),
                                                sets: $0.psetArray.compactMap { psetEntity in
                                let setVolume = SetVolume(reps: Int(psetEntity.reps),
                                                weight: psetEntity.weight,
                                                id: Int(psetEntity.id))
                                
                                return setVolume
                            }
                            )
                        }
                        workout.sets.sort { $0.id < $1.id }
                        return workout
                    }
                    model.workouts.sort { $0.id < $1.id }
                    return model
                }
                emmiter.onNext(programModels)
                emmiter.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    
    func deleteProgram(_ program: Program) {
        storage.deleteProgramEntity(program)
    }
    
    // 아직 개발 안 됨.
    func updateProgram(_ program: Program) {
        
    }
}
