//
//  HintView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-12-12.
//

import SwiftUI

struct HintView: View {
    var body: some View {
        
        VStack{
            Text("If you longpress the beer of chose you can edit, share or delete the beer!")
                .font(.title2)
                .padding(.horizontal, 16)
        }
        .padding(.top, 100)
        Spacer()
            .navigationTitle("Hints")
    }
}

#Preview {
    HintView()
}
