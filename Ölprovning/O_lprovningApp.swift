//
//  O_lprovningApp.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-16.
//

import SwiftUI

@main
struct O_lprovningApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var beerManager = BeerManager()
    @StateObject private var viewModel = BeerViewModel()
    @AppStorage("isDarkModeOn") private var isDarkModeOn = false
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 10.0
    @AppStorage("isFirstBeerAdded") private var isFirstBeerAdded = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(beerManager)
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .preferredColorScheme(isDarkModeOn ? .dark : .light)
        }
    }
}


