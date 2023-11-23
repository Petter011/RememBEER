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
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var beerTypes: FetchedResults<BeerType>
    
    @State private var showingScannedQRcodeView = false
    @State private var selectedBeerType: String? = nil
        
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0

    var body: some View {
        ZStack{
            Image("BackgroundImageBeer")
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
            VStack{
                VStack{
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(beerTypes.filter { $0.isScanned == true }, id: \.self) { scannedBeerType in
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
                }
                
                Spacer()
                VStack{
                    Button(action: {
                        showingScannedQRcodeView.toggle()
                    }, label: {
                        Text("Scan QR Code")
                            .padding()
                            .frame(maxWidth: 200, maxHeight: 60)
                            .foregroundColor(.white)
                            .font(.title3)
                            .fontWeight(.bold)
                    })
                    .background(.linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing))
                    .cornerRadius(15)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                    .padding(.bottom, 30)
                    .sheet(isPresented: $showingScannedQRcodeView) {
                        ScannedQRcodeView(
                            onSave: { newBeer, beerType in
                                beerManager.addScannedBeer(newBeer, for: beerType)
                                
                                let fetchRequest: NSFetchRequest<BeerType>
                                fetchRequest = BeerType.fetchRequest()
                                fetchRequest.predicate = NSPredicate(format: "name LIKE %@", beerType)
                                fetchRequest.fetchLimit = 1
                                let types = try? moc.fetch(fetchRequest)
                                let t: BeerType
                                if types != nil && !types!.isEmpty {
                                    t = types![0]
                                } else {
                                    t = BeerType(context: moc)
                                    t.id = UUID()
                                    t.name = beerType
                                    t.isScanned = true
                                    t.beers = []
                                }
                                
                                let beer = Beer(context: moc)
                                beer.id = UUID()
                                //beer.image = newBeer.beerImageData!
                                beer.name = newBeer.beerName
                                beer.score = newBeer.beerPoints
                                beer.note = newBeer.beerNote
                                beer.beerType?.isScanned = true
                                beer.beerType = t
                                try? moc.save()
                                
                                isBlurOn = true
                                
                            },selectedBeerType: $selectedBeerType,
                            isPresented: $showingScannedQRcodeView
                        )
                    }
                }
            }
            .safeAreaInset(edge: .top) {
                navBar(headline: "Scanned Beers")
            }
            .navigationBarHidden(true)
        }
    }
    
}
