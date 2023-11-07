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
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 2.0
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    
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
                                        Button(role: .destructive) {
                                            selectedBeer = beer
                                            showAlert = true
                                        } label:{
                                            Label("Delete", systemImage: "trash")
                                        }
                                    }
                                    .sheet(isPresented: $isShowingEditView) {
                                        if let beer = selectedBeer {
                                            EditBeerView(isShowingEditView: $isShowingEditView, viewModel: viewModel, beer: selectedBeer!)
                                        }
                                    }
                            }
                        }
                    }
                    Spacer()
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm Delete"),
                        message: Text("Are you sure you want to delete this beer?"),
                        primaryButton: .destructive(Text("Delete")) {
                            
                            if let beer = selectedBeer {
                                moc.delete(beer)
                            }
                            
                            /*if let beers = beerType.beers as? Set<Beer>, beers.count == 1 {
                             moc.delete(beerType)
                             }*/
                            
                            if let beers = beerType.beers as? Set<Beer> {
                                // Check if beerType is empty
                                if beers.isEmpty {
                                    moc.delete(beerType)
                                }
                            }
                            
                            do {
                                try moc.save()
                                
                                if let beers = beerType.beers as? Set<Beer>, beers.isEmpty {
                                    // Leave the view if no more beers are in this beerType
                                    presentationMode.wrappedValue.dismiss()
                                }
                                selectedBeer = nil
                            } catch {
                                print("Error deleting beer: \(error)")
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
                
            }
            .onAppear {
                viewModel.setSelectedBeer(nil)
            }
        }
        .sheet(isPresented: $isShowingFullScreenImage) {
            if let beer = selectedBeer {
                VStack {
                    Capsule()
                            .fill(Color.secondary)
                            .opacity(0.5)
                            .frame(width: 35, height: 5)
                            .padding(6)
                    Text(beer.beerType!.name!)
                        .font(.title)
                        .bold()
                        .foregroundColor(Color.orange)
                        .padding(.top)
                        .underline()
                    HStack{
                        Image(systemName: "mug.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                .linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing)
                            )
                            .font(.system(size: 40))
                        Text("\(beer.name!)")
                            .bold()
                            .font(.title2)
                    }
                    .padding(.top,10)
                    HStack{
                        Image(systemName: "medal.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(
                                .linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing)
                            )
                            .font(.system(size: 40))
                        Text("\(beer.score)")
                            .bold()
                            .font(.title2)
                    }
                    .padding(.top,10)
                    VStack{
                        Text(beer.note!)
                            .padding(.bottom)
                    }
                    .frame(width: 250, height: 100)
                    .shadow(radius: 10)
                    .border(Color.black, width: 3)
                    .cornerRadius(15)
                    .padding(10)
                    
                    if let image = beer.getBeerImage() {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.top)
                            .cornerRadius(15)
                    }
                }
            }
        }
        
    }
}
