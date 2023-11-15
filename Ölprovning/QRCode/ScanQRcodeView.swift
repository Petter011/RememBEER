//
//  ScanQRcodeView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-15.
//

import SwiftUI

struct ScanQRcodeView: View {
    @State private var scannedCode: String?
    //let beer: Beer
    var body: some View {
        VStack {
            if let scannedCode = scannedCode {
                // Display the scanned QR code information (e.g., beer details)
                Text("Scanned Code: \(scannedCode)")
            } else {
                // Use the QRCodeScannerView to scan QR codes
                QRCodeScannerView { code in
                    // Handle the scanned QR code value (in this case, display it)
                    self.scannedCode = code
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}


/*struct ScanQRcodeView: View {
    @State private var scannedBeer: Beer?

    var body: some View {
        VStack {
            if let scannedBeer = scannedBeer {
                // Display the scanned beer information using a custom layout
                ScannedDetailsView(beer: scannedBeer)
            } else {
                // Use the QRCodeScannerView to scan QR codes
                QRCodeScannerView { code in
                    // Handle the scanned QR code value
                    if let beer = decodeBeer(from: code) {
                        // Assign the scanned beer to the state variable
                        self.scannedBeer = beer
                    }
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }

    // Function to decode beer information from QR code
    private func decodeBeer(from code: String) -> Beer? {
        // Add your logic here to decode the beer information
        // You might need to parse the JSON or perform other decoding steps
        // Return the decoded Beer object or nil if decoding fails
        // For example, you can use JSONDecoder to decode the Beer object from the QR code string
        // Replace this example code with your actual decoding implementation
        do {
            let data = code.data(using: .utf8)!
            return try JSONDecoder().decode(Beer.self, from: data)
        } catch {
            print("Error decoding QR code: \(error)")
            return nil
        }
    }
}*/
