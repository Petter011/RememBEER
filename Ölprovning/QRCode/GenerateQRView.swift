//
//  QRCodeView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-13.
//
import SwiftUI
import CoreImage.CIFilterBuiltins

struct GenerateQRView: View {
    let beer: Beer
    @State private var qrCodeImage: UIImage?
    
    var body: some View {
        VStack {
            Spacer()
            Image(uiImage: generateQRCode(from: beer)!)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 200, height: 200)
                .overlay(
                    Image(uiImage: beer.getBeerImage() ?? UIImage(systemName: "photo")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50))
            Spacer()
        }
        .padding()
    }
    
    private func generateQRCode() {
        qrCodeImage = generateQRCode(from: beer)
    }
    
    private func generateQRCode(from beer: Beer) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        do {
            let beerData = try JSONEncoder().encode(beer)
            
            filter.setValue(beerData, forKey: "inputMessage")
            
            if let qrCodeCIImage = filter.outputImage {
                let scaleX = UIScreen.main.scale
                let transformedCIImage = qrCodeCIImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleX))
                
                if let qrCodeCGImage = context.createCGImage(transformedCIImage, from: transformedCIImage.extent) {
                    return UIImage(cgImage: qrCodeCGImage)
                }
            }
        } catch {
            print("Error encoding beer details: \(error)")
        }
        
        return nil
    }
}



