//
//  ContentView.swift
//  Beer Tests
//
//  Created by Petter Gustafsson on 2023-07-30.
//
import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        TabView{
            Group{
                BeerView()
                    .tabItem {
                        Label("My Beer", systemImage: "mug.fill")
                    }
                QRView()
                    .tabItem {
                        Label("Recived", systemImage: "qrcode")
                    }
                AllBeersView()
                    .tabItem{
                        Label("All", systemImage: "medal.fill")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "slider.horizontal.3")
                    }
            }
            .toolbarBackground(.black, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

