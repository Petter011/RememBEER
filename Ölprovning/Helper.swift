//
//  Helper.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-16.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import CoreData

func navBar() {
    
        let appearance = UINavigationBarAppearance()
        let textColor = UIColor(Color.orange.opacity(0.8))
        
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.backgroundColor = UIColor(Color.orange.opacity(0.2))
        appearance.largeTitleTextAttributes = [
            .font: UIFont(name: "GillSans-Bold", size: 32)!,
            .foregroundColor: textColor,
            .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]
        appearance.titleTextAttributes = [
            .font: UIFont(name: "GillSans-Bold", size: 32)!,
            .foregroundColor: textColor,
            .textEffect: NSAttributedString.TextEffectStyle.letterpressStyle
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

struct CustomAddButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 200, maxHeight: 60)
            .foregroundColor(.white)
            .font(.title3)
            .fontWeight(.bold)
            .background(.linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing))
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
            .padding(.bottom, 30)
    }
}

struct CustomButtonStyleSaveCancel: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .frame(maxWidth: 150, maxHeight: 60)
            .background(Color.orange)
            .cornerRadius(40)
            .shadow(color: .orange, radius: 5, y: 3)
            .overlay(RoundedRectangle(cornerRadius: 40).stroke(Color.black, lineWidth: 1))
            .padding(.bottom, 30)
    }
}

struct CustomBeerTypeButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: 150)
            .foregroundColor(.orange)
            .fontDesign(.serif)
            .font(.title2)
            .fontWeight(.bold)
            .background(Color.black.opacity(0.9))
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct BeerImage: View {
    let beer: Beer
    let isIpad: Bool
    var body: some View {
        Image(uiImage: beer.getBeerImage() ?? UIImage(systemName: "photo")!)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
            .frame(height: isIpad ? 200 : 130)
            
    }
}

extension View {
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

public extension UIImage {
    /// Resize image while keeping the aspect ratio. Original image is not modified.
    /// - Parameters:
    ///   - width: A new width in pixels.
    ///   - height: A new height in pixels.
    /// - Returns: Resized image.
    func resize(_ width: Int, _ height: Int) -> UIImage {
        // Keep aspect ratio
        let maxSize = CGSize(width: width, height: height)

        let availableRect = AVFoundation.AVMakeRect(
            aspectRatio: self.size,
            insideRect: .init(origin: .zero, size: maxSize)
        )
        let targetSize = availableRect.size

        // Set scale of renderer so that 1pt == 1px
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        // Resize the image
        let resized = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resized
    }
}

struct BackgroundImageSplitView : View {
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            Color.orange.opacity(0.2)
        }else{
            Image("BackgroundImageIphone")
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
        }
    }
}

struct BackgroundImageStandard : View {
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 1.0
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return Image("BackgroundImageIpad")
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
        } else {
            return Image("BackgroundImageIphone")
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
        }
    }
}

/*struct ScannedQRCodeHandler {
    let moc: NSManagedObjectContext
    let beerManager: BeerManager

    func handleScannedQRCode(newBeer: BeerWithImage, beerType: String, isBlurOn: inout Bool) {
        beerManager.addScannedBeer(newBeer, for: beerType)

        let fetchRequest: NSFetchRequest<BeerType> = BeerType.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name LIKE %@ AND isScanned == true", beerType)
        fetchRequest.fetchLimit = 1

        do {
            let existingTypes = try moc.fetch(fetchRequest)

            if let existingType = existingTypes.first {
                // Use the existing scanned BeerType
                existingType.isScanned = true

                let beer = Beer(context: moc)
                beer.id = UUID()
                beer.name = newBeer.beerName
                beer.score = newBeer.beerPoints
                beer.note = newBeer.beerNote
                beer.image = newBeer.beerImageData!
                beer.beerType = existingType

                try? moc.save()

                isBlurOn = true
            } else {
                // Create a new BeerType for the scanned beer
                let newType = BeerType(context: moc)
                newType.id = UUID()
                newType.name = beerType
                newType.isScanned = true
                newType.beers = []

                let beer = Beer(context: moc)
                beer.id = UUID()
                beer.name = newBeer.beerName
                beer.score = newBeer.beerPoints
                beer.note = newBeer.beerNote
                beer.image = newBeer.beerImageData!
                beer.beerType = newType

                try? moc.save()

                isBlurOn = true
            }
        } catch {
            print("Error fetching BeerTypes: \(error.localizedDescription)")
        }
    }
}*/
