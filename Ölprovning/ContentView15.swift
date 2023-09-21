//
//  ContentView15.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-09-01.
//

import SwiftUI

struct ContentView15: View {
    
    var body: some View {
        TabView{
            Group{
                BeerView()
                    .tabItem {
                        Label("ÖL", systemImage: "mug.fill")
                    }
                PicturesView()
                    .tabItem{
                        Label("Bilder", systemImage: "photo")
                    }
                PlingStatisticsView()
                    .tabItem{
                        Label("Statistik", systemImage: "rectangle.and.pencil.and.ellipsis")
                    }
                GroupView()
                    .tabItem{
                        Label("Skapa/Gå med", systemImage: "person.3.fill")
                    }
                SettingsView()
                    .tabItem{
                        Label("Inställingar", systemImage: "slider.horizontal.3")
                    }
            }
            
        }
    }
}



struct ContentView15_Previews: PreviewProvider {
    static var previews: some View {
        ContentView15()
    }
}
