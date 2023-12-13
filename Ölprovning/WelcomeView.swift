//
//  WelcomeView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-12-12.
//

import SwiftUI

struct WelcomeView: View {
    @AppStorage("isShownWelcome")  var isShownWelcome: Bool?

    var body: some View {
        NavigationStack{
            ZStack{
                Color.black
                    .ignoresSafeArea()
                VStack{
                    VStack{
                        Text("RememBEER")
                            .font(.largeTitle)
                            .foregroundColor(Color.orange)
                    }
                    .padding(.top, 20)
                    Spacer()
                    VStack{
                        Text("Welcome to RememBEER – where beer lovers share the joy of discovery! \n\nUnleash the power of QR codes to share your favorite beers with friends and fellow enthusiasts. Scan and unveil a world of flavors, ratings, and images, creating a unique experience for every beer. \n\nJoin our vibrant community, where each QR code tells a story, sparking conversations and fostering a shared passion for craft beer. Let's explore, savor, and celebrate together. \n\nCheers to the journey of beer discovery!")
                            .font(.title3)
                            .foregroundColor(Color.orange)
                            .padding(.horizontal, 16)
                    }
                    
                    
                    Spacer()
                    
                    Button(action: {
                        isShownWelcome = false
                    }) {
                        Text("Let's go")
                            .modifier(buttonColor())
                    }
                    .modifier(buttonBackgroundColor())
                    .padding(.bottom, 50)
                    
                }
                
            }
        }
    }
}
#Preview {
    WelcomeView()
}

