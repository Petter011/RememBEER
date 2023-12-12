//
//  ShowScannedBeerView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-12-07.
//

/*import SwiftUI

struct ShowScannedBeerView: View {
    var scannedBeer: ScannedBeer?
    @State var scannedBeerImage: UIImage?

    var body: some View {
        VStack {
            Text(scannedBeer!.beerType.name)
                .font(.title)
                .fontWeight(.heavy)
                .padding(.top)
                .underline()
            
            HStack {
                Text("\(scannedBeer!.name)")
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
                Text("\(scannedBeer!.score)/10")
                    .bold()
                    .font(.title2)
            }
            .padding(.top,10)
            
            VStack{
                Text(scannedBeer!.note)
                    .padding(.bottom)
                    .padding(.leading)
                    .padding(.trailing)
            }
            .frame(width: 250, height: 100)
            .shadow(radius: 10)
            .border(Color.black, width: 3)
            .cornerRadius(15)
            .padding(.top, 30)
            
            VStack{
                if let scannedBeerImage = scannedBeerImage {
                    Image(uiImage: scannedBeerImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100) // Adjust the size as needed
                }
            }
        }
    }
}

#Preview {
    ShowScannedBeerView()
}*/
