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
            List{
                Text("If you longpress the beer of chose you can edit, share or delete the beer!")
                    .font(.title2)
                Text("When you seach in All Beers you can seach both by name or points.")
                    .font(.title2)
            }
            .scrollContentBackground(.hidden)
        }
        .padding(.top, 100)
        Spacer()
            .navigationTitle("Hints")
    }
}

#Preview {
    HintView()
}
