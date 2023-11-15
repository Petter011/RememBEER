//
//  QRView.swift
//  RememBEER
//
//  Created by Petter Gustafsson on 2023-11-15.
//

import SwiftUI

struct QRView: View {
    
   
    var body: some View {
        NavigationStack{
            ZStack{
                Image("BackgroundImageBeer")
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                VStack{
                    Spacer()
                    VStack{
                        NavigationLink(destination:  ScanQRcodeView()) {
                            Text("Scan QR Code")
                                .padding()
                                .frame(maxWidth: 200, maxHeight: 60)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                        .background(.linearGradient(colors: [.orange, .black], startPoint: .top, endPoint: .bottomTrailing))
                        .cornerRadius(15)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.white, lineWidth: 1))
                        .padding(.bottom, 30)
                    }
                }
                .safeAreaInset(edge: .top) {
                   navBar()
                }
                .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    QRView()
}
