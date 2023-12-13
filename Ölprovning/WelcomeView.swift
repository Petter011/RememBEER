//
//  WelcomeView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-12-12.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack{
            VStack{
                Text("Welcome to RememBEER")
                    .font(.title)
                    .foregroundColor(Color.orange)
                Spacer()
                Text("RememBEER lets you ")
                    .foregroundColor(Color.orange)
            }
            
        }
        .background(.black)
        
        
    }
}

#Preview {
    WelcomeView()
}
