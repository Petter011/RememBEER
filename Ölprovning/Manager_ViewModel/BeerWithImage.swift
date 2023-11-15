//
//  SwiftUIView.swift
//  Beer Tests
//
//  Created by Petter Gustafsson on 2023-08-07.
//
import SwiftUI
import Foundation
import CoreData



extension Beer: Encodable {
    enum CodingKeys: CodingKey {
        case id, name, score, note, beerType
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(score, forKey: .score)
        try container.encode(note, forKey: .note)

        // Encode the relationship if it exists
        if let beerType = beerType {
            try container.encode(beerType, forKey: .beerType)
        }
    }
}

extension BeerType: Encodable {
    enum CodingKeys: CodingKey {
        case id, name
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }
}

extension Beer {
    func getBeerImage() -> UIImage? {
        if image != nil {
            return UIImage(data: image!)
        }
        return nil
    }
}

struct BeerWithImage: Identifiable, Codable {
    var id = UUID()
    var beerType: String
    var beerPoints: Int16
    var beerName: String
    let beerImageData: Data?
    var beerNote: String
    
    // Method to convert beerImageData to UIImage
    func getBeerImage() -> UIImage? {
        if let imageData = beerImageData {
            return UIImage(data: imageData)
        }
        return nil
    }
}
