//
//  ProgramEntity+CoreDataClass.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//
//

import CoreData

@objc(ProgramEntity)
public class ProgramEntity: NSManagedObject {

}

extension ProgramEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgramEntity> {
        return NSFetchRequest<ProgramEntity>(entityName: "ProgramEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var programToWorkout: Set<WorkoutEntity>?

    // 내부에 있는 id를 갖고 정렬하는 코드인데 정확히는 잘 모르겠음
     public var workoutArray: [WorkoutEntity] {
         return programToWorkout!.sorted {
             return $0.id > $1.id
         }
     }
}

// MARK: Generated accessors for programToWorkout
extension ProgramEntity {

    @objc(addProgramToWorkoutObject:)
    @NSManaged public func addToProgramToWorkout(_ value: WorkoutEntity)

    @objc(removeProgramToWorkoutObject:)
    @NSManaged public func removeFromProgramToWorkout(_ value: WorkoutEntity)

    @objc(addProgramToWorkout:)
    @NSManaged public func addToProgramToWorkout(_ values: NSSet)

    @objc(removeProgramToWorkout:)
    @NSManaged public func removeFromProgramToWorkout(_ values: NSSet)

}

extension ProgramEntity : Identifiable {

}
