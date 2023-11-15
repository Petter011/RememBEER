//
//  QRCodeView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-13.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

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
            Spacer()
        }
        .padding()
        .background(Color.secondary.opacity(0.5))
    }
    
    private func generateQRCode() {
        qrCodeImage = generateQRCode(from: beer)
    }
    
    private func generateQRCode(from beer: Beer) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        
        do {
            let beerData = try JSONEncoder().encode(beer)
            var beerDictionary = try JSONSerialization.jsonObject(with: beerData, options: []) as! [String: Any]
            
            // Use a reference to an external image instead of embedding it
                    //beerDictionary["imageReference"] = "https://example.com/path/to/image.jpg"

            
            // Add image data to the dictionary
            /*if let imageData = beer.getBeerImage()?.jpegData(compressionQuality: 1.0) {
                let base64String = imageData.base64EncodedString()
                beerDictionary["imageData"] = base64String
                print("Base64 string: \(base64String)")
            } else {
                print("Image data is nil")
            }*/


            let jsonData = try JSONSerialization.data(withJSONObject: beerDictionary, options: [])
            filter.setValue(jsonData, forKey: "inputMessage")
            
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
