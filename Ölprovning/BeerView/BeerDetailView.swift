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
    
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 2.0
    @State private var isFirstBeerAdded = UserDefaults.standard.bool(forKey: "isFirstBeerAdded")
    @Environment(\.managedObjectContext) var moc

    
    
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
                                                print("Edit button pressed")
                                            } label:{
                                                Label("Edit", systemImage: "pencil.and.scribble")
                                            }
                                            Button(role: .destructive) {
                                                // Check if a beer is selected
                                                guard let beer = selectedBeer else {
                                                    print("No beer selected, do nothing")
                                                    return
                                                }
                                                do {
                                                    moc.delete(beer)
                                                    try? moc.save()
                                                    selectedBeer = nil
                                                }
                                                
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
                        //.padding(15)
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
                    /*HStack{
                        Image(systemName: "list.clipboard.fill")
                            .symbolRenderingMode(.palette)
                                .foregroundStyle(
                                    .linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing)
                                )
                                .font(.system(size: 30))
                        Text("Note")
                            .underline()
                    }
                    .padding(.top,10)*/
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



