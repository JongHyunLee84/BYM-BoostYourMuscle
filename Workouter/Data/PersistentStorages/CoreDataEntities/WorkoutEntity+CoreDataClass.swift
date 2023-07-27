//
//  WorkoutEntity+CoreDataClass.swift
//  Workouter
//
//  Created by 이종현 on 2023/04/06.
//
//

import CoreData

@objc(WorkoutEntity)
public class WorkoutEntity: NSManagedObject {

}

extension WorkoutEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntity> {
        return NSFetchRequest<WorkoutEntity>(entityName: "WorkoutEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var rest: Int64
    @NSManaged public var target: String?
    @NSManaged public var id: Int64
    @NSManaged public var workoutToProgram: ProgramEntity?
    @NSManaged public var workoutToSetVolume: Set<SetVolumeEntity>?
    
    public var setVolumeArray: [SetVolumeEntity] {
        return workoutToSetVolume!.sorted {
            return $0.id > $1.id
        }
    }

}

// MARK: Generated accessors for workoutToSetVolume
extension WorkoutEntity {

    @objc(addWorkoutToSetVolumeObject:)
    @NSManaged public func addToWorkoutToSetVolume(_ value: SetVolumeEntity)

    @objc(removeWorkoutToSetVolumeObject:)
    @NSManaged public func removeFromWorkoutToSetVolume(_ value: SetVolumeEntity)

    @objc(addWorkoutToSetVolume:)
    @NSManaged public func addToWorkoutToSetVolume(_ values: NSSet)

    @objc(removeWorkoutToSetVolume:)
    @NSManaged public func removeFromWorkoutToSetVolume(_ values: NSSet)

}

extension WorkoutEntity : Identifiable {

}
