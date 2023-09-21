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
    @State private var isButtonTapped = false


    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 10.0
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
                    .padding(.top, 20)

                    Spacer()

                    Button(action: {
                        showingAddBeerView.toggle()
                    }) {
                        Text("Lägg till")
                            .padding()
                            .frame(maxWidth: 120, maxHeight: 40)
                            .foregroundColor(.black)
                            .background(Color.orange)
                            .cornerRadius(15)
                            .font(.title3)
                            .shadow(radius: 40)
                    }
                    .offset(x: isButtonTapped ? -5 : 0, y: 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                            isButtonTapped.toggle()
                        }
                    }
                    .padding(.bottom, 20)
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
            .navigationTitle("ÖL")
            
        }
    }

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.orange]
    }
}

struct BeerView_Previews: PreviewProvider {
    static var previews: some View {
        BeerView()
    }
}
