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
                        Label("Lägg Till", systemImage: "person.3.fill")
                    }
                SettingsView()
                    .tabItem{
                        Label("Inställingar", systemImage: "slider.horizontal.3")
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
