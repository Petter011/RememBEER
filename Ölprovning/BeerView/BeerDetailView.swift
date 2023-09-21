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
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 10.0
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")


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
                        .padding()
                    
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                            ForEach(beerType.beers?.allObjects as? [Beer] ?? []) { beer in
                                // Use a combined gesture for both tap and long-press
                                Image(uiImage: beer.getBeerImage() ?? UIImage(systemName: "photo")!)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 130)
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
                                                        selectedBeer = beer
                                                    }
                                            )
                                    )
                                    .contextMenu { // Add a context menu for long-press action
                                        Button("Redigera") {
                                            // Implement edit action
                                            
                                        }
                                        Button("Ta bort") {
                                            // Check if a beer is selected
                                            guard let selectedBeer = selectedBeer else {
                                                print("No beer selected, do nothing")
                                                return // No beer selected, do nothing
                                            }
                                            
                                            // Get the non-optional beer type
                                            let nonOptionalBeerType = selectedBeer.beerType
                                            
                                            print("Deleting beer with ID: \(selectedBeer.id) from type: \(nonOptionalBeerType)")
                                            
                                            // Remove the selected beer from the data source
                                           /* if var beersOfType = beerManager.beers[nonOptionalBeerType] {
                                                // Filter out the selected beer
                                                beersOfType.removeAll { $0.id == selectedBeer.id }
                                                // Update the dictionary with the modified array
                                                beerManager.beers[nonOptionalBeerType] = beersOfType
                                                
                                                print("Beer removed successfully")
                                            } else {
                                                print("Beer type not found in data source")
                                            }*/
                                        }
                                    }
                            }
                        }
                    }

                        .padding()
                    }
                }
                .onAppear {
                    viewModel.setSelectedBeer(nil)
                }
            }
            .fullScreenCover(isPresented: $isShowingFullScreenImage) {
                if let beer = selectedBeer {
                    VStack {
                        Text(beer.beerType!.name!)
                            .font(.title)
                            .bold()
                            .foregroundColor(Color.orange)
                            .padding(.top)

                        Text(beer.name!)
                            .font(.title2)
                            .bold()
                            .foregroundColor(Color.orange)

                        Text(beer.who!)
                            .bold()
                            .foregroundColor(Color.orange)

                        Text("\(beer.score) Poäng")
                            .bold()
                            .foregroundColor(Color.orange)
                            .padding(.bottom)

                        if let image = beer.getBeerImage() {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .edgesIgnoringSafeArea(.top)
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                _ = UIScreen.main.bounds.width
                                let screenHeight = UIScreen.main.bounds.height
                                if value.translation.height > screenHeight / 8 {
                                    isShowingFullScreenImage = false // Swipe down to close
                                }
                            }
                        )
                    }
                }
            }
        }
    

