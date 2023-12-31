//
//  ScanQRcodeView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-15.
//

import SwiftUI

struct ScannedQRcodeView: View {
    @State private var scannedBeer: ScannedBeer?
    //@ObservedObject var viewModel: BeerViewModel
    let onSave: (BeerWithImage, String) -> Void

    var body: some View {
        VStack {
            // Display the decoded beer information
            if let scannedBeer = scannedBeer {
                VStack {
                    Text(scannedBeer.beerType.name)
                        .font(.title)
                        .fontWeight(.heavy)
                        .padding(.top)
                        .underline()
                    
                    HStack {
                        Text("\(scannedBeer.name)")
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
                        Text("\(scannedBeer.score)/10")
                            .bold()
                            .font(.title2)
                    }
                    .padding(.top,10)
                    
                    VStack{
                        Text(scannedBeer.note)
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
                    
                    
                    Button(action: {
                        let QrBeer = BeerWithImage(beerType: beerType, beerPoints: beerPoints, beerName: beerName, beerNote: beerNote)
                        onSave(QrBeer, beerType)
                    }, label: {
                        Text("Save")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: 200, maxHeight: 60)
                    })
                    .background(Color.orange)
                    .cornerRadius(40)
                    .shadow(color: .orange, radius: 5, y: 3)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
                   .padding(.bottom, 30)
                    
                    
                    /*Image(uiImage: scannedBeer.getBeerImage()!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)*/
                }
                // Add other properties as needed
            } else {
                // Use the QRCodeScannerView to scan QR codes
                QRCodeScannerView { code in
                    // Handle the scanned QR code value (in this case, decode it)
                    decodeScannedCode(code)
                }
                .onAppear {
                    // You can also trigger decoding here if needed
                    // decodeScannedCode(initialCode)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }

    private func decodeScannedCode(_ code: String) {
        // Attempt to decode the scanned code
        if let jsonData = code.data(using: .utf8) {
            do {
                scannedBeer = try JSONDecoder().decode(ScannedBeer.self, from: jsonData)
            } catch {
                print("Error decoding scanned code: \(error)")
            }
        }
    }
}
