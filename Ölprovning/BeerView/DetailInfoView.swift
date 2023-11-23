//
//  DetailInfoView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-16.
//

import SwiftUI

struct DetailInfoView: View {
    var beerType: BeerType
    var beer: Beer
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.secondary)
                .opacity(0.5)
                .frame(width: 35, height: 5)
                .padding(6)
            
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
            .padding(.top,10)
            
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
        //.background(.linearGradient(colors: [.lightOrange, .lightOrange2], startPoint: .top, endPoint: .bottom))
    }
}
