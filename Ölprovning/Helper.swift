//
//  Helper.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-16.
//

import Foundation
import SwiftUI


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
