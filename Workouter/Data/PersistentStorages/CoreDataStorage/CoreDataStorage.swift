//
//  CoreDataStorage.swift
//  Workouter
//
//  Created by 이종현 on 2023/07/04.
//
import CoreData
import UIKit

final class CoreDataStorage {
    
    static let shared = CoreDataStorage()
    private init() {}
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var persistentContainer = appDelegate?.persistentContainer
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer?.performBackgroundTask(block)
    }
}
