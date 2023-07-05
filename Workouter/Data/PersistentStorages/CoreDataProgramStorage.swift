//
//  CoreDataRepository.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//

import UIKit
import CoreData

final class CoreDataProgramStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    private let programEntityStr = "ProgramEntity"

    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    private func fetchRequst() -> NSFetchRequest<ProgramEntity> {
        let request: NSFetchRequest = NSFetchRequest<ProgramEntity>(entityName: programEntityStr)
        // 추후 sortDescription 등등 추가
        return request
    }
    
    func fetchProgramEntities(completion: @escaping ([ProgramEntity]) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequst()
                let requestEntity = try context.fetch(fetchRequest)
                completion(requestEntity)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func saveProgramEntity(_ program: Program) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let entityData = ProgramEntity(context: context)
                entityData.title = program.title
                // id 숫자를 저장해서 fetch해 올때 save된 순서대로 갖고 올 거임
                var exerciseId: Int64 = 0
                program.exercises.forEach { exerciseModel in
                    var psetId: Int64 = 0
                    let exerciseEntity = ExerciseEntity(context: context)
                    exerciseEntity.rest = Int64(exerciseModel.rest)
                    exerciseEntity.target = exerciseModel.target.rawValue
                    exerciseEntity.name = exerciseModel.name
                    exerciseEntity.id = exerciseId
                    exerciseId += 1
                    exerciseModel.sets.forEach {
                        let entity = PsetEntity(context: context)
                        entity.reps = Int64($0.reps)
                        entity.weight = $0.weight
                        entity.id = psetId
                        psetId += 1
                        exerciseEntity.addToExerciseToPset(entity)
                    }
                    entityData.addToProgramToExercise(exerciseEntity)
                }
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteProgramEntity(_ program: Program) {
        coreDataStorage.performBackgroundTask { context in
            do {
                if let result = try context.fetch(self.fetchRequst()).filter({
                    // TODO: 일단 Program title이 같으면 삭제 -> Program 추가할 때 이미 존재하는 title이 있다면 저장 못 하게.
                    $0.title == program.title
                }).first {
                    context.delete(result)
                }
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}

