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

struct QRCodeView: View {
    let beer: Beer
    @State private var qrCodeImage: UIImage?
    @Binding var isShowingQRCode: Bool
    
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
            let beerString = String(data: beerData, encoding: .utf8)
            let data = Data(beerString!.utf8)

            filter.setValue(data, forKey: "inputMessage")

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
