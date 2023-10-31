//
//  AddBeer.swift
//  Beer Tests
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
    
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 2.0
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")
    
    
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var beerTypes: FetchedResults<BeerType>
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("BackgroundImageBeer")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
                
                VStack(spacing: 20) {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(beerTypes, id: \.self) { beerType in
                                NavigationLink(
                                    destination: BeerDetailView(viewModel: viewModel, beerType: beerType),
                                    label: {
                                        Text(beerType.name!)
                                            .padding()
                                            .frame(maxWidth: 150)
                                            .foregroundColor(.orange)
                                            .background(Color.black)
                                            .cornerRadius(15)
                                            .font(.title2)
                                            .shadow(radius: 5)
                                    }
                                )
                            }
                        }
                    }
                    .safeAreaInset(edge: .top) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack() {
                                Text("Beer")
                                    .font(.largeTitle.weight(.bold))
                                    .foregroundStyle(Color.orange)
                                Spacer()
                            }
                        }
                        .padding()
                        .background(LinearGradient(colors: [.black.opacity(0.1), .orange.opacity(0.3)],
                                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                            .overlay(.ultraThinMaterial)
                        )
                    }
                    .navigationBarHidden(true)
                    .tint(.orange)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddBeerView.toggle()
                    }) {
                        Text("Add beer")
                            .padding()
                            .frame(maxWidth: 140, maxHeight: 50)
                            .foregroundColor(.black)
                            .background(Color.orange)
                            .cornerRadius(15)
                            .font(.title3)
                            .shadow(radius: 40)
                    }
                    .padding(.bottom, 30)
                    .sheet(isPresented: $showingAddBeerView) {
                        AddBeerView(
                            onSave: { newBeer, beerType in
                                beerManager.addBeer(newBeer, for: beerType)
                                
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
                                    t.beers = []
                                }
                                
                                let beer = Beer(context: moc)
                                beer.id = UUID()
                                beer.image = newBeer.beerImageData!
                                beer.name = newBeer.beerName
                                beer.who = newBeer.beerWho
                                beer.score = newBeer.beerPoints
                                beer.note = newBeer.beerNote
                                beer.beerType = t
                                try? moc.save()
                                
                                
                                // Set isFirstBeerAdded to true
                                isFirstBeerAdded = true
                                UserDefaults.standard.set(isFirstBeerAdded, forKey: "isFirstBeerAdded")
                                
                                // Apply blur when the first beer is added
                                isBlurOn = true
                            },
                            selectedBeerType: $selectedBeerType,
                            isPresented: $showingAddBeerView
                        )
                    }
                }
            }
        }
    }
}


struct BeerView_Previews: PreviewProvider {
    static var previews: some View {
        BeerView()
    }
}
