//
//  Points.swift
//  Beer Tests
//
//  Created by Petter Gustafsson on 2023-08-05.
//

/*import SwiftUI

struct CashRegisterView: View {
    @State private var saldo: Int = UserDefaults.standard.integer(forKey: "saldoKey")
    @State private var newSaldo: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("BackgroundImageFootball")
                    //.resizable()
                    //.aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    //.edgesIgnoringSafeArea(.all)
                VStack {
                    Text("Saldo: \(saldo)kr")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                    
                    TextField("Nytt saldo", text: $newSaldo)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
                        .padding()
                        .keyboardType(.decimalPad)
                        
                    
                    Button("Uppdatera Saldo") {
                        if let updatedSaldo = Int(newSaldo) {
                            saldo = updatedSaldo
                            newSaldo = ""
                            UserDefaults.standard.set(saldo, forKey: "saldoKey") // Save the new saldo value
                        }
                        
                    }
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.orange)
                }
            }
            .onAppear {
                // Load the saved saldo value from UserDefaults
                saldo = UserDefaults.standard.integer(forKey: "saldoKey")
            }
        }
    }
}
 */
