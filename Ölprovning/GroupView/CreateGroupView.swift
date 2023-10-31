//
//  CreateGroup.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-28.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit

let context = CIContext()
let filter = CIFilter.qrCodeGenerator()

/*func generateUniqueCode() -> String {
    let uuid = UUID().uuidString
    // Extract a portion of the UUID to create a shorter code
    let code = uuid.prefix(8) // You can adjust the length as needed
    return String(code)
}*/

func generateQRCode(from string: String) -> UIImage {
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")
    
    if let qrCodeCIImage = filter.outputImage {
        let scaleX = UIScreen.main.scale
        let transformedCIImage = qrCodeCIImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleX))
        
        if let qrCodeCGImage = context.createCGImage(transformedCIImage, from: transformedCIImage.extent) {
            return UIImage(cgImage: qrCodeCGImage)
        }
    }
    
    return UIImage(systemName: "xmark") ?? UIImage()
}

struct CreateGroupView: View {
    @State private var groupName: String = ""
    @State private var qrCodeImage: UIImage? = nil // To store the generated QR code image
    //@State private var qrCodes: [String: UIImage] = [:] // Dictionary to store QR codes


    var body: some View {
        NavigationStack {
            

                VStack {
                    Text("Ny grupp")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding()

                    TextField("Namn", text: $groupName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button(action: createQRCode) {
                        Text("Generera QR kod")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(30)
                    }

                    if qrCodeImage != nil {
                        Image(uiImage: qrCodeImage!)
                            .resizable()
                            .interpolation(.none)
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }

                    Spacer()
                }
            
        }
    }

    private func createQRCode() {
        guard !groupName.isEmpty else {
            // Handle invalid input, e.g., show an alert
            return
        }

        // Generate a unique code
        //let uniqueCode = generateUniqueCode()

        // Store the roundName and uniqueCode in your data model or database
        // You might want to use a database like Firebase or CoreData for this purpose.

        // Generate the QR code image
        let qrCode = generateQRCode(from: groupName)
        
        // Assign the generated QR code image to qrCodeImage
        qrCodeImage = qrCode

    }
}


struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView()
    }
}
