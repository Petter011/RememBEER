//
//  AllBeerView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-12-13.
//

import SwiftUI
import CoreData

struct AllBeersView: View {
    @EnvironmentObject var beerManager: BeerManager
    @EnvironmentObject var viewModel: BeerViewModel
    @Environment(\.managedObjectContext) private var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var allBeers: FetchedResults<Beer>
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var beerTypes: FetchedResults<BeerType>
    @Environment(\.presentationMode) var presentationMode
    @State private var searchText = ""
    @State private var selectedBeer: Beer? // New state variable for selected beer
    @State private var isShowingFullScreenImage = false
    @State private var isShowingEditView = false
    @State private var isShowingGenerateQRView = false
    @State private var showAlert = false
    @State private var isIpad: Bool = false
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0
    
    var filteredBeers: [Beer] {
        if searchText.isEmpty {
            return Array(allBeers.sorted(by: { $0.score > $1.score }))
        } else {
            return allBeers.filter { beer in
                let nameMatches = beer.name?.contains(searchText) == true
                let scoreMatches = String(beer.score).localizedCaseInsensitiveContains(searchText)
                return nameMatches || scoreMatches
            }
            .sorted(by: { $0.score > $1.score })
        }
    }

    var body: some View {
        NavigationStack{
            ZStack {
                Image("BackgroundImageBeer")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)

                VStack {
                    ScrollView {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: isIpad ? 6 : 3), spacing: 20) {
                            ForEach(filteredBeers) { beer in
                                BeerItemView(beer: beer, isIpad: isIpad)
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
                                    .sheet(isPresented: $isShowingFullScreenImage) {
                                        if let beer = selectedBeer {
                                            DetailInfoView(beerType: beer.beerType!, beer: beer)
                                        }
                                    }
                                    .sheet(isPresented: $isShowingGenerateQRView) {
                                        if let beer = selectedBeer {
                                            GenerateQRView(beer: beer)
                                        }
                                    }
                                    .sheet(isPresented: $isShowingEditView) {
                                        if let beer = selectedBeer {
                                            EditBeerView(isShowingEditView: $isShowingEditView, viewModel: viewModel, beer: beer, beerType: beer.beerType!)
                                        }
                                    }
                            }
                        }
                    }
                    Spacer()
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
                            
                            if let beerType = selectedBeer?.beerType, let beers = beerType.beers as? Set<Beer>, beers.count == 1 {
                                    moc.delete(beerType)
                                }
                                try moc.save()
                            
                        }catch {
                            print("Error deleting beer: \(error)")
                        }
                        
                        selectedBeer = nil
                    },
                    secondaryButton: .cancel()
                )
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("All Beer")
            .searchable(text: $searchText, prompt: "Search by name or rating")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
                    navBar()
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





/*#Preview {
    AllBeerView()
}*/
