//
//  ScanQRcodeView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-15.
//

import SwiftUI
import Firebase
import FirebaseStorage

struct ScannedQRcodeView: View {
    @EnvironmentObject var beerManager: BeerManager
    @EnvironmentObject var viewModel: BeerViewModel
    @State private var scannedBeer: ScannedBeer?
    @State private var scannedBeerImage: UIImage?
    @State private var shouldScan: Bool = true
    
    let onSave: (BeerWithImage, String) -> Void
    
    @Binding var selectedBeerType: String?
    @Binding var isPresented: Bool
    var body: some View {
        VStack {
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
                    .border(Color.black, width: 1)
                    .cornerRadius(15)
                    .padding(.top, 30)
                    
                    
                    
                    if let image = scannedBeer.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(15)
                            .padding(.bottom, 20)
                    }
                }
                
                Spacer()
                
                HStack {
                    Button(action: {
                        guard let imageUrlString = scannedBeer.imageUrl else {
                            print("No image URL available for deletion")
                            return
                        }
                        deleteScannedBeer(urlString: imageUrlString)
                        isPresented = false
                    }, label: {
                        Text("Cancel")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: 150, maxHeight: 60)
                    })
                    .background(Color.orange)
                    .cornerRadius(40)
                    .shadow(color: .orange, radius: 5, y: 3)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
                    .padding(.bottom, 30)
                    .padding(.leading, 15)
                    
                    Spacer()
                    
                    Button(action: {
                        saveScannedBeer()
                        
                        guard let imageUrlString = scannedBeer.imageUrl else {
                            print("No image URL available for deletion")
                            return
                        }
                        deleteScannedBeer(urlString: imageUrlString)
                    }, label: {
                        Text("Save")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: 150, maxHeight: 60)
                    })
                    .background(Color.orange)
                    .cornerRadius(40)
                    .shadow(color: .orange, radius: 5, y: 3)
                    .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
                    .padding(.bottom, 30)
                    .padding(.trailing, 15)
                }
                
                
            } else {
                // Use the QRCodeScannerView to scan QR codes
                QRCodeScannerView(didFindCode: { code in
                    // Handle the scanned code
                    decodeScannedCode(code)
                    
                    
                    // Stop scanning
                    self.shouldScan = false
                }, shouldScan: $shouldScan)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private func saveScannedBeer() {
        if let beer = scannedBeer {
            let newBeer = BeerWithImage(
                beerType: beer.beerType.name,
                beerPoints: Int16(beer.score),
                beerName: beer.name,
                beerImageData: beer.imageData,
                beerNote: beer.note
            )
            onSave(newBeer, beer.beerType.name)
            isPresented = false
        }
    }
    
    private func deleteScannedBeer(urlString: String) {
        // Create a reference to the file to delete
        let imageRef = Storage.storage().reference(forURL: urlString)
        
        // Delete the file
        imageRef.delete { error in
            if let error = error {
                print("Error deleting image from Firebase Storage: \(error.localizedDescription)")
                // Handle the error, if needed
            } else {
                print("Image deleted successfully from Firebase Storage")
                // File deleted successfully
            }
        }
    }
    
    
    private func decodeScannedCode(_ code: String) {
        guard let jsonData = code.data(using: .utf8) else {
            print("Invalid QR code format")
            return
        }
        print("QR Code Content: \(code)")
        
        do {
            let decoder = JSONDecoder()
            scannedBeer = try decoder.decode(ScannedBeer.self, from: jsonData)
            print("JSON Data: \(String(data: jsonData, encoding: .utf8) ?? "Invalid JSON")")
            
            // Extract the image URL from the decoded JSON
            guard let imageUrlString = scannedBeer?.imageUrl, !imageUrlString.isEmpty,
                  let imageUrl = URL(string: imageUrlString) else {
                print("Invalid or missing image URL")
                return
            }
            print("Image URL: \(imageUrlString)")
            
            // Fetch image data from Firebase Storage
            fetchImageFromFirebaseStorage(url: imageUrl) { imageData in
                // Set the fetched image data to the scannedBeer
                scannedBeer?.imageData = imageData
                
                //self.saveScannedBeer()
            } stopScanningCallback: {
                
            }
        } catch {
            print("Error decoding scanned code: \(error)")
        }
    }
    
    private func fetchImageFromFirebaseStorage(url: URL, completion: @escaping (Data?) -> Void, stopScanningCallback: @escaping () -> Void) {
        print("Fetching image from: \(url)")
        
        // Create a reference to the file you want to download in Firebase Storage
        let imageRef = Storage.storage().reference(forURL: url.absoluteString)
        print("URL absoluteString: \(url.absoluteString)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print("Error downloading image from Firebase Storage: \(error)")
                completion(nil)
                stopScanningCallback()
                
            } else {
                // Call the completion handler with the downloaded image data
                completion(data)
                stopScanningCallback()
                
            }
        }
    }
}



