//
//  QRCodeView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-13.
//
import SwiftUI
import CoreImage.CIFilterBuiltins
import FirebaseStorage
import Firebase

struct GenerateQRView: View {
    let beer: Beer
    @State private var qrCodeImage: UIImage?
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            Spacer()
            if let qrCodeImage = qrCodeImage {
                Image(uiImage: qrCodeImage)
                    .resizable()
                    .interpolation(.none)
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .overlay(
                        Image(uiImage: beer.getBeerImage() ?? UIImage(systemName: "photo")!)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .frame(width: 100, height: 100)
                        
                    )
            } else {
                if isLoading {
                    // Show activity indicator while loading
                    ProgressView("Creating QR Code...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.orange)
                } else {
                    Text("Error generating QR code")
                        .foregroundColor(.red)
                }
                
            }
            Spacer()
        }
        .padding()
        .onAppear {
            generateQRCode()
        }
    }
    
    private func generateQRCode() {
        isLoading = true
        uploadImageToFirebaseStorage()
    }
    
    private func uploadImageToFirebaseStorage() {
        if let originalImage = beer.getBeerImage() {
            // Resize the image to a desired width and height
            let resizedImage = originalImage.resize(500, 500)
            
            // Convert the resized image to data with compression quality
            if let imageData = resizedImage.jpegData(compressionQuality: 1.0) {
                let storage = Storage.storage()
                let storageRef = storage.reference()
                let imageRef = storageRef.child("beer_images").child(UUID().uuidString + ".jpg")
                
                imageRef.putData(imageData, metadata: nil) { metadata, error in
                    defer {
                        isLoading = false
                    }
                    guard metadata != nil, error == nil else {
                        print("Error uploading image to Firebase Storage: \(error?.localizedDescription ?? "Unknown error")")
                        isLoading = false
                        return
                    }
                    
                    // Retrieve the download URL and generate the QR code
                    imageRef.downloadURL { url, error in
                        guard let downloadURL = url, error == nil else {
                            print("Error getting download URL: \(error?.localizedDescription ?? "Unknown error")")
                            isLoading = false
                            return
                        }
                        print(downloadURL.absoluteString)
                        generateQRCode(with: downloadURL.absoluteString)
                    }
                }
            } else {
                // Handle case where image data couldn't be generated
                print("Error converting resized image to data.")
                isLoading = false
            }
        } else {
            // Handle case where there is no image
            generateQRCode(with: "")
        }
    }
    
    
    private func generateQRCode(with imageUrl: String) {
        do {
            
            beer.imageUrl = imageUrl // Add imageUrl to the beer data
            
            let jsonencoder = JSONEncoder()
            jsonencoder.outputFormatting = .withoutEscapingSlashes
            
            let beerData = try jsonencoder.encode(beer)
            
            print("Encoded beer data: \(String(data: beerData, encoding: .utf8) ?? "")")
            print("Image URL: \(imageUrl)")
            
            let filter = CIFilter.qrCodeGenerator()
            filter.setValue(beerData, forKey: "inputMessage")
            
            if let qrCodeCIImage = filter.outputImage {
                let scaleX = UIScreen.main.scale
                let transformedCIImage = qrCodeCIImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleX))
                
                let context = CIContext()
                if let qrCodeCGImage = context.createCGImage(transformedCIImage, from: transformedCIImage.extent) {
                    // Ensure UI updates on the main thread
                    DispatchQueue.main.async {
                        self.qrCodeImage = UIImage(cgImage: qrCodeCGImage)
                    }
                }
            }
        } catch {
            print("Error encoding beer details: \(error)")
        }
    }
}

