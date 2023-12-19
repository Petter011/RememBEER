//
//  BeerManager.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-18.
//

import Foundation
import SwiftUI


class BeerManager: ObservableObject {
    @Published var addedBeers: [String: [BeerWithImage]] = [:]
    @Published var scannedBeers: [String: [BeerWithImage]] = [:]
    @Published var selectedBeer: Beer? = nil
        
    func addBeer(_ beer: BeerWithImage, for type: String) {
        if addedBeers[type] == nil {
            addedBeers[type] = []
        }
        addedBeers[type]?.append(beer)
    }
    
    func addScannedBeer(_ beer: BeerWithImage, for type: String) {
        if scannedBeers[type] == nil {
            scannedBeers[type] = []
        }
        scannedBeers[type]?.append(beer)
        
        
    }
}





