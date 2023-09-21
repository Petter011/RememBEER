//
//  SwiftUIView.swift
//  Beer Tests
//
//  Created by Petter Gustafsson on 2023-08-07.
//
import SwiftUI
import Foundation

extension Beer {
    func getBeerImage() -> UIImage? {
        if image != nil {
            return UIImage(data: image!)
        }
        return nil
    }
}

struct BeerWithImage: Identifiable {
    var id = UUID()
    var beerType: String
    var beerWho: String
    var beerPoints: Int16
    var beerName: String
    let beerImageData: Data?
    //var participatens: String
    
    // Method to convert beerImageData to UIImage
    func getBeerImage() -> UIImage? {
        if let imageData = beerImageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}
