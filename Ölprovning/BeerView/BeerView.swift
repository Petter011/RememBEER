//
//  AddBeer.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-07-30.
//
import SwiftUI
import CoreData
import SwiftUIX

struct BeerView: View {
    @EnvironmentObject var beerManager: BeerManager
    @EnvironmentObject var viewModel: BeerViewModel
    @Environment(\.managedObjectContext) var moc
    //var beer : Beer
    @State private var showingAddBeerView = false
    @State private var selectedBeerType: String? = nil
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")
    @State private var searchText = ""
    
    var addedBeers: [BeerType] {
        let uppercaseSearchText = searchText.uppercased()

        if searchText.isEmpty {
            return beerTypes.filter { $0.isScanned == false }
        } else {
            return beerTypes.filter { $0.isScanned == false && $0.name?.uppercased().contains(uppercaseSearchText) == true }
        }
    }
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "isScanned", ascending: false)]) var beerTypes: FetchedResults<BeerType>

    var body: some View {
        NavigationStack{
            ZStack {
                Image("BackgroundImageBeer")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
                
                VStack(spacing: 20) {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(addedBeers, id: \.self) { addedBeerType in
                                NavigationLink(
                                    destination: BeerDetailView(viewModel: viewModel, beerType: addedBeerType),
                                    label: {
                                        Text(addedBeerType.name == nil ? "" : addedBeerType.name!)
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
                        showingAddBeerView.toggle()
                    }, label: {
                        Text("Add beer")
                            .modifier(buttonColor())
                    })
                    .modifier(buttonBackgroundColor())
                    .sheet(isPresented: $showingAddBeerView) {
                        AddBeerView(
                            onSave: { newBeer, beerType in
                                beerManager.addBeer(newBeer, for: beerType)
                                
                                let fetchRequest: NSFetchRequest<BeerType>
                                fetchRequest = BeerType.fetchRequest()
                                fetchRequest.predicate = NSPredicate(format: "name LIKE %@ AND isScanned == false", beerType)
                                fetchRequest.fetchLimit = 1
                                let types = try? moc.fetch(fetchRequest)
                                let addType: BeerType
                                if let existingType = types?.first {
                                    addType = existingType
                                    addType.isScanned = false
                                    
                                } else {
                                    addType = BeerType(context: moc)
                                    addType.id = UUID()
                                    addType.name = beerType
                                    addType.isScanned = false
                                    addType.beers = []
                                }
                                
                                let beer = Beer(context: moc)
                                beer.id = UUID()
                                beer.image = newBeer.beerImageData!
                                beer.name = newBeer.beerName
                                beer.score = newBeer.beerPoints
                                beer.note = newBeer.beerNote
                                beer.beerType = addType
                                try? moc.save()
                                
                                isBlurOn = true
                            },
                            selectedBeerType: $selectedBeerType,
                            isPresented: $showingAddBeerView
                        )
                    }
                }
            }
            .ignoresSafeArea(.keyboard)
            .navigationTitle("My Beer")
            .searchable(text: $searchText, prompt: "Search Beer")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
                    navBar()
                }
    }
}

#Preview {
    BeerView()
}



