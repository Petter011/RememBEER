//
//  O_lprovningApp.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-16.
//

import SwiftUI

var globalParticipantNames: [String] = UserDefaults.standard.stringArray(forKey: "participantNames") ?? []


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
            if #available(iOS 16.0, *) {
                ContentView()
                    .environmentObject(beerManager)
                    .environmentObject(viewModel)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .preferredColorScheme(isDarkModeOn ? .dark : .light)
            } else {
                ContentView15()
                    .environmentObject(beerManager)
                    .environmentObject(viewModel)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .preferredColorScheme(isDarkModeOn ? .dark : .light)
            }
        }
    }
    
    init() {
           loadParticipantNames()
       }

       func loadParticipantNames() {
           if let savedNames = UserDefaults.standard.array(forKey: "participantNames") as? [String] {
               globalParticipantNames = savedNames
           }
       }
   }


