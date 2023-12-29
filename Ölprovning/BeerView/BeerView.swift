//
//  AddBeer.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-07-30.
//
import SwiftUI
import CoreData

struct BeerView: View {
    @EnvironmentObject var beerManager: BeerManager
    @EnvironmentObject var viewModel: BeerViewModel
    @Environment(\.managedObjectContext) var moc
    @State private var showingAddBeerView = false
    @State private var selectedBeerType: String? = nil
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")
    @State private var searchText = ""
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true), NSSortDescriptor(key: "isScanned", ascending: false)]) var beerTypes: FetchedResults<BeerType>

    var addedBeers: [BeerType] {
        let uppercaseSearchText = searchText.uppercased()

        if searchText.isEmpty {
            return beerTypes.filter { $0.isScanned == false }
        } else {
            return beerTypes.filter { $0.isScanned == false && $0.name?.uppercased().contains(uppercaseSearchText) == true }
        }
    }
    
    var body: some View {
        NavigationSplitView{
            ZStack {
                BackgroundImageSplitView()
                VStack(spacing: 20) {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 30) {
                            ForEach(addedBeers, id: \.self) { addedBeerType in
                                NavigationLink(
                                    destination: BeerDetailView(viewModel: viewModel, beerType: addedBeerType),
                                    label: {
                                        Text(addedBeerType.name == nil ? "" : addedBeerType.name!)
                                    }
                                )
                                .buttonStyle(CustomBeerTypeButtonStyle())
                            }
                        }
                    }
                    Button(action: {
                        showingAddBeerView.toggle()
                    }, label: {
                        Text("Add beer")
                    })
                    .buttonStyle(CustomAddButtonStyle())
                    .sheet(isPresented: $showingAddBeerView) {
                        AddBeerView(
                            onSave: { newBeer, beerType in
                                handleAddedBeer(newBeer: newBeer, beerType: beerType)
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
            
        }detail:{
            if let selectedBeerType = addedBeers.first {
                BeerDetailView(viewModel: viewModel, beerType: selectedBeerType)
            }else {
                Image("BackgroundImageIpad")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
            }
        }
        .onAppear {
                    navBar()
                }
    }
    
    func handleAddedBeer(newBeer: BeerWithImage, beerType: String) {
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
    }
}



#Preview {
    BeerView()
}




