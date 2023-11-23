//
//  BeerManager.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-18.
//

import Foundation
import SwiftUI


class BeerManager: ObservableObject {
    @Published var beers: [String: [BeerWithImage]] = [:]
    @Published var scannedbeers: [String: [BeerWithImage]] = [:]
    @Published var selectedBeer: Beer? = nil
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var beerTypes: FetchedResults<BeerType>

    
    func addBeer(_ beer: BeerWithImage, for type: String) {
        if beers[type] == nil {
            beers[type] = []
        }
        beers[type]?.append(beer)
    }
    
    func addScannedBeer(_ beer: BeerWithImage, for type: String) {
        if scannedbeers[type] == nil {
            scannedbeers[type] = []
        }
        scannedbeers[type]?.append(beer)
        
        
    }
}





