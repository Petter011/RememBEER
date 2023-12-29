//
//  DataController.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-09-03.
//


import CoreData
import Foundation

class DataController: ObservableObject{
    let container = NSPersistentCloudKitContainer(name: "Model")
    
    init() {
        container.loadPersistentStores{
            description, error in if let error = error {
                print("Core Data faild to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        do {
              try container.viewContext.setQueryGenerationFrom(.current)
        } catch {
             fatalError("Failed to pin viewContext to the current generation:\(error)")
        }
    }
}
