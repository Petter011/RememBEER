//
//  QRView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-15.
//

import SwiftUI
import CoreData

struct QRView: View {
    @EnvironmentObject var beerManager: BeerManager
    @EnvironmentObject var viewModel: BeerViewModel
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "isScanned", ascending: true)]) var beerTypes: FetchedResults<BeerType>
    
    @State private var showingScannedQRcodeView = false
    @State private var selectedBeerType: String? = nil
    @State private var searchText = ""
    
    var scannedBeers: [BeerType] {
        let uppercaseSearchText = searchText.uppercased()

        if searchText.isEmpty {
            return beerTypes.filter { $0.isScanned == true }
        } else {
            return beerTypes.filter { $0.isScanned == true && $0.name?.uppercased().contains(uppercaseSearchText) == true }
        }
    }
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("BackgroundImageBeer")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
                VStack(spacing: 20) {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(scannedBeers, id: \.self) { scannedBeerType in
                                NavigationLink(
                                    destination: BeerDetailView(viewModel: viewModel, beerType: scannedBeerType),
                                    label: {
                                        Text(scannedBeerType.name!)
                                            .padding()
                                            .frame(maxWidth: 150)
                                            .foregroundColor(.orange)
                                            .font(.title2)
                                            .fontWeight(.bold)
                                    }
                                )
                            }
                            .background(Color.black)
                            .cornerRadius(15)
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        }
                    }
                    Button(action: {
                        showingScannedQRcodeView.toggle()
                    }, label: {
                        Text("Scan QR Code")
                            .modifier(buttonColor())
                    })
                    .modifier(buttonBackgroundColor())
                    .sheet(isPresented: $showingScannedQRcodeView) {
                        ScannedQRcodeView(
                            onSave: { newBeer, beerType in
                                beerManager.addScannedBeer(newBeer, for: beerType)
                                
                                let fetchRequest: NSFetchRequest<BeerType> = BeerType.fetchRequest()
                                fetchRequest.predicate = NSPredicate(format: "name LIKE %@ AND isScanned == true", beerType)
                                fetchRequest.fetchLimit = 1
                                
                                do {
                                    let existingTypes = try moc.fetch(fetchRequest)
                                    
                                    if let existingType = existingTypes.first {
                                        // Use the existing scanned BeerType
                                        existingType.isScanned = true
                                        
                                        let beer = Beer(context: moc)
                                        beer.id = UUID()
                                        beer.name = newBeer.beerName
                                        beer.score = newBeer.beerPoints
                                        beer.note = newBeer.beerNote
                                        beer.image = newBeer.beerImageData!
                                        beer.beerType = existingType
                                        
                                        try? moc.save()
                                        
                                        isBlurOn = true
                                    } else {
                                        // Create a new BeerType for the scanned beer
                                        let newType = BeerType(context: moc)
                                        newType.id = UUID()
                                        newType.name = beerType
                                        newType.isScanned = true
                                        newType.beers = []
                                        
                                        let beer = Beer(context: moc)
                                        beer.id = UUID()
                                        beer.name = newBeer.beerName
                                        beer.score = newBeer.beerPoints
                                        beer.note = newBeer.beerNote
                                        beer.image = newBeer.beerImageData!
                                        beer.beerType = newType
                                        
                                        try? moc.save()
                                        
                                        isBlurOn = true
                                    }
                                } catch {
                                    print("Error fetching BeerTypes: \(error.localizedDescription)")
                                }
                            },
                            selectedBeerType: $selectedBeerType,
                            isPresented: $showingScannedQRcodeView
                        )
                    }
                }
                .ignoresSafeArea(.keyboard)

            }
            .navigationTitle("Received Beers")
            .searchable(text: $searchText, prompt: "Search Beer")
            .navigationBarTitleDisplayMode(.inline)
            /*.safeAreaInset(edge: .top) {
                navBar(headline: (String(localized: "Received Beers")))
            }
            .navigationBarHidden(true)*/
        }
        .onAppear {
                    navBar()
                }
    }
}
#Preview {
    QRView()
}

