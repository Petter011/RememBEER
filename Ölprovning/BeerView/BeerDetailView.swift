//
//  BeerDetailView.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-16.
//

import SwiftUI

struct BeerDetailView: View {
    @EnvironmentObject var beerManager: BeerManager
    @ObservedObject var viewModel: BeerViewModel
    var beerType: BeerType
    
    @State private var isShowingFullScreenImage = false
    @State private var selectedBeer: Beer? // New state variable for selected beer
    @State private var isShowingEditView = false
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 2.0
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")
    @Environment(\.managedObjectContext) var moc

    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("BackgroundImageBeer")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
                
                
                VStack {
                    Text(beerType.name!)
                        .font(.title)
                        .underline()
                        .foregroundColor(Color.orange)
                        //.padding()
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                            ForEach(beerType.beers?.allObjects as? [Beer] ?? []) { beer in
                                // Use a combined gesture for both tap and long-press
                                Image(uiImage: beer.getBeerImage() ?? UIImage(systemName: "photo")!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 130)
                                    .cornerRadius(10)
                                    .gesture(
                                        TapGesture()
                                            .onEnded { _ in
                                                viewModel.setSelectedBeer(beer)
                                                selectedBeer = beer
                                                isShowingFullScreenImage = true
                                            }
                                            .sequenced(before:
                                                        LongPressGesture(minimumDuration: 1)
                                                .onEnded { _ in
                                                    viewModel.setSelectedBeer(beer)
                                                    selectedBeer = beer
                                                    
                                                }
                                                      )
                                    )
                                    .contextMenu { 
                                        Button {
                                            print("Edit button pressed")
                                            viewModel.setSelectedBeer(beer) 
                                            isShowingEditView = true // Present the edit view
                                            selectedBeer = beer
                                        } label:{
                                            Label("Edit", systemImage: "pencil.and.scribble")
                                        }
                                        .sheet(isPresented: $isShowingEditView) {
                                            // Present the edit view here
                                            EditBeerView(isShowingEditView: $isShowingEditView, viewModel: viewModel, beer: beer)
                                        }
                                        Button(role: .destructive) {
                                            // Check if a beer is selected
                                            guard let beer = selectedBeer else {
                                                print("No beer selected, do nothing")
                                                return
                                            }
                                            
                                            
                                            do {
                                                moc.delete(beer)
                                                try? moc.save()
                                                selectedBeer = nil
                                            } 
                                            
                                        } label:{
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .onAppear {
                viewModel.setSelectedBeer(nil)
            }
        }
        .sheet(isPresented: $isShowingFullScreenImage) {
            if let beer = selectedBeer {
                VStack {
                    Text(beer.beerType!.name!)
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.orange)
                        .padding(.top)
                        .underline()
                        .padding(15)
                    HStack{
                        Text("Name: \(beer.name!)")
                            //.font(.title2)
                            .bold()
                        //.foregroundColor(Color.orange)
                            .padding(10)
                        
                        Text(" Points: \(beer.score)")
                            .bold()
                        //.foregroundColor(Color.orange)
                            .padding(10)
                    }
                    Text("Note")
                        .underline()
                    Text(beer.note!)
                        //.bold()
                        //.foregroundColor(Color.orange)
                        .padding(.bottom)
                        .padding(10)
                    
                    
                    if let image = beer.getBeerImage() {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.top)
                            .cornerRadius(15)
                    }
                }
            }
        }
    }
}



