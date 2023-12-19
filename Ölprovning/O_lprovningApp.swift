//
//  O_lprovningApp.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-16.
//

import SwiftUI
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct O_lprovningApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var beerManager = BeerManager()
    @StateObject private var viewModel = BeerViewModel()
    @AppStorage("isDarkModeOn") private var isDarkModeOn = false
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 10.0
    @AppStorage("isFirstBeerAdded") private var isFirstBeerAdded = false
    @AppStorage("isShownWelcome") private var isShownWelcome: Bool = true

    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


    var body: some Scene {
        WindowGroup {
            if isShownWelcome{
                WelcomeView()
            } else{
                ContentView()
                    .environmentObject(beerManager)
                    .environmentObject(viewModel)
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .preferredColorScheme(isDarkModeOn ? .dark : .light)
                    .accentColor(.orange)
            }
        }
    }
}


