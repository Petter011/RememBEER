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
    @AppStorage("blurRadius") private var blurRadius = 1.0
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
                                        Divider()
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
                            .padding(.leading)
                            .padding(.trailing)
                    }
                    .frame(width: 250, height: 100)
                    .shadow(radius: 10)
                    .border(Color.black, width: 3)
                    .cornerRadius(15)
                    .padding(.top, 30)
                    
                    Spacer()
                    
                    if let image = beer.getBeerImage() {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .edgesIgnoringSafeArea(.top)
                            .cornerRadius(15)
                            .padding(.bottom, 30)
                    }
                }
            }
        }
        
    }
}
