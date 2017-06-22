//
//  CoreDataManager.swift
//  Reader
//
//  Created by 张海南 on 2017/6/21.
//  Copyright © 2017年 枫韵海. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    static let sharedInstance = CoreDataManager()
    
    let context: NSManagedObjectContext
    private let psc: NSPersistentStoreCoordinator
    private let model: NSManagedObjectModel
    private let store: NSPersistentStore?
    
    private override init() {
        let modelName = "Reader"
        
        let bundle = Bundle.main
        let modelURL = bundle.url(forResource: modelName, withExtension: "momd")
        model = NSManagedObjectModel(contentsOf: modelURL!)!
        
        psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        
        let documentsURL = self.applicationSupportDirectory
        let storeURL = documentsURL.appendingPathComponent("\(modelName).sqlite")
        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
        
        do {
            store = try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            NOVELLog("Failed to add persistent store: \(error)")
            abort()
        }
    }
    
    func newContext() -> NSManagedObjectContext? {
        var someContext: NSManagedObjectContext? = nil
        
        someContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        someContext?.persistentStoreCoordinator = self.psc
        
        return someContext
    }
    
    private var applicationDocumentsDirectory: URL = {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0]
    }()
    
    private var applicationSupportDirectory: URL = {
        let fileManager = FileManager.default
        let url = try! fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return url
    }()
    
    private func saveContext() {
        do {
            if context.hasChanges {
                try context.save()
            }
        } catch let error as NSError {
            NOVELLog("Failed to save: \(error)")
            abort()
        }
    }
}
