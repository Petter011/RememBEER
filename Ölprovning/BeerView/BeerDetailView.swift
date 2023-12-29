//
//  BeerDetailView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-08-16.
//

import SwiftUI

struct BeerDetailView: View {
    @EnvironmentObject var beerManager: BeerManager
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BeerViewModel
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var DetailBeers: FetchedResults<Beer>
    
    @State private var isShowingFullScreenImage = false
    @State private var selectedBeer: Beer? // New state variable for selected beer
    @State private var isShowingEditView = false
    @State private var showAlert = false
    @State private var isShowingGenerateQRView = false
    @State private var isShowingScannedDetails = false
    @State private var searchText = ""
    @State private var isIpad: Bool = false
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0
    
    var beerType: BeerType
    
    var filteredBeer: [Beer] {
        let filteredBeers = DetailBeers.filter { beer in
            return beer.beerType == beerType &&
            (searchText.isEmpty ||
             (beer.name?.localizedCaseInsensitiveContains(searchText) == true) ||
             (String(beer.score).localizedCaseInsensitiveContains(searchText)))
        }
        return filteredBeers.sorted(by: { $0.score > $1.score })
    }
    
    var body: some View {
        NavigationStack{
            ZStack {
                BackgroundImageStandard()
                VStack {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: isIpad ? 6 : 3), spacing: isIpad ? 50 : 20) {
                            ForEach(filteredBeer) { beer in
                                BeerImage(beer: beer, isIpad: isIpad)
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
                                            Label("Share with QR Code", systemImage: "qrcode")
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
                                            EditBeerView(isShowingEditView: $isShowingEditView, viewModel: viewModel, beer: beer, beerType: beerType)
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
            .ignoresSafeArea(.keyboard)
            .navigationTitle(Text(beerType.name == nil ? "" : beerType.name!))
            .searchable(text: $searchText, prompt: "Search Beer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.setSelectedBeer(nil)
            isIpad = UIDevice.current.userInterfaceIdiom == .pad
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

