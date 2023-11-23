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
    @State private var showAlert = false
    @State private var isShowingGenerateQRView = false
    @State private var isShowingScannedDetails = false
    @State private var scannedBeer: Beer?
    
    
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        ZStack {
            Image("BackgroundImageBeer")
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
            
            VStack {
                Text(beerType.name == nil ? "" : beerType.name!)
                    .font(.title)
                    .fontWeight(.bold)
                    .underline()
                    .foregroundColor(Color.orange)
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                        ForEach(beerType.beers?.allObjects as? [Beer] ?? []) { beer in
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
                                        viewModel.setSelectedBeer(beer)
                                        isShowingEditView = true
                                        selectedBeer = beer
                                    } label:{
                                        Label("Edit", systemImage: "pencil.and.scribble")
                                    }
                                    Button {
                                        viewModel.setSelectedBeer(beer)
                                        selectedBeer = beer
                                        isShowingGenerateQRView = true
                                    }label: {
                                        Label("QR Code", systemImage: "qrcode")
                                    }
                                    
                                    Divider()
                                    
                                    Button(role: .destructive) {
                                        selectedBeer = beer
                                        showAlert = true
                                    } label:{
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
                                .sheet(isPresented: $isShowingGenerateQRView) {
                                    if let beer = selectedBeer {
                                        GenerateQRView(beer: beer)
                                    }
                                }
                                .sheet(isPresented: $isShowingEditView) {
                                    if let beer = selectedBeer {
                                        EditBeerView(isShowingEditView: $isShowingEditView, viewModel: viewModel, beer: beer)
                                    }
                                }
                                .sheet(isPresented: $isShowingFullScreenImage) {
                                    if let beer = selectedBeer {
                                        DetailInfoView(beerType: beerType, beer: beer)
                                    }
                                }
                        }
                    }
                }
                /*.navigationTitle(beerType.name == nil ? "" : beerType.name!)
                 .toolbarBackground(.hidden)*/
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Are you sure you want to delete this beer?"),
                    primaryButton: .destructive(Text("Delete")) {
                        
                        do {
                            if let beer = selectedBeer {
                                moc.delete(beer)
                            }
                            
                            if let beers = beerType.beers as? Set<Beer>, beers.count == 1 {
                                moc.delete(beerType)
                            }
                            
                            try moc.save()
                        }catch {
                            print("Error deleting beer: \(error)")
                        }
                        
                        let beers = beerType.beers as? Set<Beer>
                        if beers == nil || beers!.isEmpty {
                            presentationMode.wrappedValue.dismiss()
                        }
                        selectedBeer = nil
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .onAppear {
            viewModel.setSelectedBeer(nil)
        }
        
    }
    
    
    
    // Helper method to encode beer details
    private func encodeBeerDetails() -> String {
        // Create a JSONEncoder and encode beer details
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        do {
            let beerData = try encoder.encode(selectedBeer)
            return String(data: beerData, encoding: .utf8) ?? ""
        } catch {
            print("Error encoding beer details: \(error)")
            return ""
        }
    }
}

