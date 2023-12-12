//
//  BeerViewModel.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-18.
//

import Foundation

class BeerViewModel: ObservableObject {
    @Published var addedBeers: [String: [BeerWithImage]] = [:]
    @Published var scannedBeers: [String: [BeerWithImage]] = [:]
    @Published var selectedBeer: Beer? = nil

    // Function to add a new beer
    func addBeer(_ beer: BeerWithImage, for type: String) {
        if addedBeers[type] == nil {
            addedBeers[type] = []
        }
        addedBeers[type]?.append(beer)
    }
    
    func addscannedBeer(_ beer: BeerWithImage, for type: String) {
        if scannedBeers[type] == nil {
            scannedBeers[type] = []
        }
        scannedBeers[type]?.append(beer)
    }

    // Function to set the selected beer
    func setSelectedBeer(_ beer: Beer?) {
        selectedBeer = beer
    }
}
