//
//  CoreDataRepository.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//

import UIKit
import CoreData

final class CoreDataRepository {
    
    static let shared = CoreDataRepository()
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    private let programEntityStr = "ProgramEntity"
    private let exerciseEntityStr = "ExerciseEntity"
    private let psetEntityStr = "PsetEntity"
    
    func fetchProgramFromCoreData() -> [ProgramEntity] {
        var programList: [ProgramEntity] = []
        if let context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.programEntityStr)
                do {
                    if let fetchedList = try context.fetch(request) as? [ProgramEntity] {
                        programList = fetchedList
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        return programList
    }
    
    func saveProgram(_ program: Program) {
        if let context, let entity = NSEntityDescription.entity(forEntityName: self.programEntityStr, in: context), let programData = NSManagedObject(entity: entity, insertInto: context) as? ProgramEntity {
            programData.title = program.title
            
            program.exercises.forEach { exerciseModel in
                guard let description = NSEntityDescription.entity(forEntityName: self.exerciseEntityStr, in: context) else { print("description nill"); return }
                let exerciseEntity = ExerciseEntity(entity: description, insertInto: context)
                exerciseEntity.rest = Int64(exerciseModel.rest)
                exerciseEntity.target = exerciseModel.target.rawValue
                exerciseEntity.name = exerciseModel.name
                exerciseModel.sets.forEach {
                    guard let description = NSEntityDescription.entity(forEntityName: self.psetEntityStr, in: context) else { print("fail making desciption"); return }
                    let entity = PsetEntity(entity: description, insertInto: context)
                    entity.reps = Int64($0.reps)
                    entity.weight = $0.weight
                    exerciseEntity.addToExerciseToPset(entity) }
                
                programData.addToProgramToExercise(exerciseEntity)
            }
            
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func deleteProgram(_ program: Program) {
        if let context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.programEntityStr)
            
            do {
                guard let fetchedProgramList = try context.fetch(request) as? [ProgramEntity] else { print("fetch failed"); return }
                guard let willBeDeleted = fetchedProgramList.filter({ $0.title == program.title }).first else { print("filter failed"); return }
                context.delete(willBeDeleted)
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // 당장은 구현 필요 없을듯
    func deleteExercise() {}
}
