//
//  CoreDataManager.swift
//  app
//
//  Created by Muune on 2023/03/08.
//

import Foundation
import UIKit
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
       let persistentContainer: NSPersistentContainer
       
       init() {
           persistentContainer = NSPersistentContainer(name: "CoreData")
           persistentContainer.loadPersistentStores { description, error in
               if let error {
                   fatalError("Unable to load Core Data Model (\(error))")
               }
           }
       }
    
//    static let shared = CoreDataManager()
//    private let persistentContainer: NSPersistentContainer
//
//    private init() {
//        persistentContainer = NSPersistentContainer(name: "CoreData")
//        persistentContainer.loadPersistentStores { description, error in
//            if let error {
//                fatalError("Unable to load Core Data Model (\(error))")
//            }
//        }
//    }
//
//    var viewContext: NSManagedObjectContext {
//        persistentContainer.viewContext
//    }
//
//    func getAllLog() throws -> [LogInfo] {
//        let request = LogInfo.fetchRequest()
//        request.sortDescriptors = []
//        return try viewContext.fetch(request)
//    }
//
//    func saveLog(name: String, email: String, uuid: String, person: Int64, time: String) throws {
//        let log = LogInfo(context: viewContext)
//        log.name = name
//        log.email = email
//        log.uuid = uuid
//        log.person = person
//        log.time = time
//
//        try viewContext.save()
//    }
    
}
