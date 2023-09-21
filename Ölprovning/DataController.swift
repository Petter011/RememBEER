//
//  DataController.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-09-03.
//


import CoreData
import Foundation

class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "Model")
    
    init() {
        container.loadPersistentStores{
            description, error in if let error = error {
                print("Core Data faild to load: \(error.localizedDescription)")
            }
        }
    }
}
