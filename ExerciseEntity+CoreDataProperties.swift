//
//  ExerciseEntity+CoreDataProperties.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//
//

import Foundation
import CoreData


extension ExerciseEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
        return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
    }

    @NSManaged public var target: String?
    @NSManaged public var name: String?
    @NSManaged public var rest: Int64
    @NSManaged public var exerciseToProgram: ProgramEntity?
    @NSManaged public var exerciseToPset: Set<PsetEntity>?
    
    public var psetArray: [PsetEntity] {
        return exerciseToPset!.sorted {
            return $0.id > $1.id
        }
    }


}

// MARK: Generated accessors for exerciseToPset
extension ExerciseEntity {

    @objc(addExerciseToPsetObject:)
    @NSManaged public func addToExerciseToPset(_ value: PsetEntity)

    @objc(removeExerciseToPsetObject:)
    @NSManaged public func removeFromExerciseToPset(_ value: PsetEntity)

    @objc(addExerciseToPset:)
    @NSManaged public func addToExerciseToPset(_ values: NSSet)

    @objc(removeExerciseToPset:)
    @NSManaged public func removeFromExerciseToPset(_ values: NSSet)

}

extension ExerciseEntity : Identifiable {

}
