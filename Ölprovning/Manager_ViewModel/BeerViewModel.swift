//
//  BeerViewModel.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-18.
//

import SwiftUI

class BeerViewModel: ObservableObject {
    @Published var beers: [String: [BeerWithImage]] = [:]
    @Published var selectedBeer: Beer? = nil

    // Function to add a new beer
    func addBeer(_ beer: BeerWithImage, for type: String) {
        if beers[type] == nil {
            beers[type] = []
        }
        beers[type]?.append(beer)
    }

    // Function to set the selected beer
    func setSelectedBeer(_ beer: Beer?) {
        selectedBeer = beer
    }
}
