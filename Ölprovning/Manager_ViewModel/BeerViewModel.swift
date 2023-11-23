//
//  BeerViewModel.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-18.
//

import Foundation

class BeerViewModel: ObservableObject {
    @Published var beers: [String: [BeerWithImage]] = [:]
    @Published var scannedbeers: [String: [BeerWithImage]] = [:]
    @Published var selectedBeer: Beer? = nil

    // Function to add a new beer
    func addBeer(_ beer: BeerWithImage, for type: String) {
        if beers[type] == nil {
            beers[type] = []
        }
        beers[type]?.append(beer)
    }
    
    func addscannedBeer(_ beer: BeerWithImage, for type: String) {
        if scannedbeers[type] == nil {
            scannedbeers[type] = []
        }
        scannedbeers[type]?.append(beer)
    }

    // Function to set the selected beer
    func setSelectedBeer(_ beer: Beer?) {
        selectedBeer = beer
    }
}
