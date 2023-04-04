//
//  PsetEntity+CoreDataProperties.swift
//  BYM
//
//  Created by 이종현 on 2023/04/04.
//
//

import Foundation
import CoreData


extension PsetEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PsetEntity> {
        return NSFetchRequest<PsetEntity>(entityName: "PsetEntity")
    }

    @NSManaged public var reps: Int64
    @NSManaged public var weight: Double
    @NSManaged public var check: Bool
    @NSManaged public var psetToExercise: ExerciseEntity?

}

extension PsetEntity : Identifiable {

}
