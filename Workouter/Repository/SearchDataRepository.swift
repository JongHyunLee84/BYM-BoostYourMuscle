//
//  SearchDataRepository.swift
//  Workouter
//
//  Created by 이종현 on 2023/06/27.
//

import UIKit
import CoreData

final class SearchDataRepository {
    
    static let shared = SearchDataRepository()
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    private let searchEntityStr = "SearchEntity"
    
    func fetchSearchEntitiesFromCoreData() -> [SearchEntity] {
        var searchList: [SearchEntity] = []
        if let context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.searchEntityStr)
            do {
                if let fetchedList = try context.fetch(request) as? [SearchEntity] {
                    searchList = fetchedList
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        return searchList
    }
    
    func saveExercises(_ exercises: [Exercise]) {
        if let context,
           let entity = NSEntityDescription.entity(forEntityName: self.searchEntityStr, in: context),
           let programData = NSManagedObject(entity: entity, insertInto: context) as? SearchEntity {
            exercises.forEach { exercise in
                programData.bodyPart = exercise.target.rawValue
                programData.equipment = exercise.equipment
                programData.gifURL = exercise.gifUrl
                programData.name = exercise.name
                if context.hasChanges {
                    do {
                        try context.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

