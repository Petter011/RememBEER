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


struct navBar: View {
    
    var headline = ""
    var body: some View {
        VStack() {
            HStack() {
                Spacer()
                Text(headline)
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(Color.orange)
                Spacer()
            }
        }
        .padding()
        .background(LinearGradient(colors: [.black.opacity(0.1), .orange.opacity(0.6)],
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
            .overlay(.ultraThinMaterial)
        )
    }
}

struct buttonColor: ViewModifier{
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: 200, maxHeight: 60)
            .foregroundColor(.white)
            .font(.title3)
            .fontWeight(.bold)
    }
}

struct buttonBackgroundColor: ViewModifier{
    func body(content: Content) -> some View {
        content
            .background(.linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing))
            .cornerRadius(15)
            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
            .padding(.bottom, 30)
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
