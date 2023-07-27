//
//  SetVolumeEntity+CoreDataClass.swift
//  BYM
//
//  Created by 이종현 on 2023/04/06.
//
//

import CoreData

@objc(SetVolumeEntity)
public class SetVolumeEntity: NSManagedObject {

}

extension SetVolumeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetVolumeEntity> {
        return NSFetchRequest<SetVolumeEntity>(entityName: "SetVolumeEntity")
    }

    @NSManaged public var check: Bool
    @NSManaged public var reps: Int64
    @NSManaged public var weight: Double
    @NSManaged public var id: Int64
    @NSManaged public var setVolumeToWorkout: WorkoutEntity?

}

extension SetVolumeEntity : Identifiable {

}
