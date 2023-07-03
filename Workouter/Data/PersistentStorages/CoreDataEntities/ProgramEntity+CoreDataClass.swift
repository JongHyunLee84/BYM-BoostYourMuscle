//
//  ProgramEntity+CoreDataClass.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//
//

import Foundation
import CoreData

@objc(ProgramEntity)
public class ProgramEntity: NSManagedObject {

}

extension ProgramEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgramEntity> {
        return NSFetchRequest<ProgramEntity>(entityName: "ProgramEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var programToExercise: Set<ExerciseEntity>?

    // 내부에 있는 id를 갖고 정렬하는 코드인데 정확히는 잘 모르겠음
     public var exerciseArray: [ExerciseEntity] {
         return programToExercise!.sorted {
             return $0.id > $1.id
         }
     }
}

// MARK: Generated accessors for programToExercise
extension ProgramEntity {

    @objc(addProgramToExerciseObject:)
    @NSManaged public func addToProgramToExercise(_ value: ExerciseEntity)

    @objc(removeProgramToExerciseObject:)
    @NSManaged public func removeFromProgramToExercise(_ value: ExerciseEntity)

    @objc(addProgramToExercise:)
    @NSManaged public func addToProgramToExercise(_ values: NSSet)

    @objc(removeProgramToExercise:)
    @NSManaged public func removeFromProgramToExercise(_ values: NSSet)

}

extension ProgramEntity : Identifiable {

}
