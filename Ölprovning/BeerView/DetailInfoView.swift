//
//  DetailInfoView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-16.
//

import SwiftUI
import CoreData

struct DetailInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var beerTypes: FetchedResults<BeerType>

    var beerType: BeerType
    var beer: Beer
    var body: some View {
            Capsule()
                .fill(Color.secondary)
                .opacity(0.5)
                .frame(width: 35, height: 5)
                .padding(6)
        
        VStack {
                Text(beer.beerType!.name!)
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(.top)
                    .underline()
    
            HStack {
                Text("\(beer.name!)")
                    .fontWeight(.medium)
                    .font(.title)
                    .fontDesign(.serif)
            }
            .padding(.top,5)
            
            HStack{
                Image(systemName: "medal.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(
                        .linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing)
                    )
                    .font(.system(size: 40))
                Text("\(beer.score)/10")
                    .bold()
                    .font(.title2)
            }
            .padding(.top,5)
            
            VStack{
                Text(beer.note!)
                    .padding(.bottom)
                    .padding(.leading)
                    .padding(.trailing)
            }
            .frame(width: 250, height: 100)
            .shadow(radius: 10)
            .border(Color.black, width: 1)
            .cornerRadius(15)
            .padding(.top, 20)
            
            Spacer()
            
            if let image = beer.getBeerImage() {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    //.edgesIgnoringSafeArea(.top)
                    .cornerRadius(15)
                    //.padding(.bottom, 20)
            }
            
            if beerType.isScanned == true {
                Button(action: {
                    // Check for existing BeerType or create a new one
                    if let existingBeerType = beerTypes.first(where: { $0.name == beerType.name && $0.isScanned == false }) {
                        // Associate the beer with the existing beerType
                        beer.beerType = existingBeerType
                    } else {
                        // Create a new BeerType only if a similar one doesn't exist
                        let newBeerType = BeerType(context: moc)
                        newBeerType.id = UUID()
                        newBeerType.name = beerType.name
                        newBeerType.isScanned = false
                        
                        beer.beerType = newBeerType
                    }
                    do {
                        try moc.save()
                        
                        presentationMode.wrappedValue.dismiss()
                        // Check if the beerType should be deleted
                        if let beers = beerType.beers as? Set<Beer>, beers.isEmpty {
                            moc.delete(beerType)
                        }
                        
                        try moc.save()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        print("Error saving to Core Data: \(error.localizedDescription)")
                        // Handle the error as needed
                    }
                    
                    let beers = beerType.beers as? Set<Beer>
                    if beers == nil || beers!.isEmpty {
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Save to My Beer")
                        .foregroundStyle(.orange)
                        .padding(8)
                })
            }
            //Spacer()
        }
        //.background(.linearGradient(colors: [.lightOrange, .lightOrange2], startPoint: .top, endPoint: .bottom))
    }
}

