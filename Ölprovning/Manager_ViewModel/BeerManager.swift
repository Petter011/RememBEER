//
//  Classes.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-18.
//

import SwiftUI
import Foundation
import CoreData

class BeerManager: ObservableObject {
    @Published var beers: [String: [BeerWithImage]] = [:]
    @Published var selectedBeer: Beer? = nil

    func addBeer(_ beer: BeerWithImage, for type: String) {
        if beers[type] == nil {
            beers[type] = []
        }
        beers[type]?.append(beer)
    }
    
   /* // Function to set the selected beer
    func setSelectedBeer(_ beer: Beer?) {
        selectedBeer = beer
    }
    // Function to delete a beer
       func deleteBeer(_ beer: BeerWithImage, from type: String, in context: NSManagedObjectContext) {
           if let index = beers[type]?.firstIndex(where: { $0.id == beer.id }) {
               // Remove the beer from the list
               beers[type]?.remove(at: index)

               // Delete the beer from Core Data
               //context.delete(beer)
           }
       }*/
}





