//
//  AddPlingStatisticsView.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-21.
//

import SwiftUI

struct AddPlingStatisticsView: View {
    @State private var selectedDate = Date()
    @State private var amount: Int = 0
    @State private var house: String = ""
    @State private var saldo: String = ""
    @State private var globalParticipantNames: [String] = UserDefaults.standard.stringArray(forKey: "participantNames") ?? []
   
    var onSave: (PlingStatistics) -> Void
    @Binding var isPresented: Bool
    
    
    var body: some View {
        NavigationStack {
                VStack(spacing: 20) {
                    Group {
                        Text("Lägg till statistik")
                            .font(.headline)
                            .padding(.top, 20)
                        
                        
                        Section {
                            DatePicker("", selection: $selectedDate, displayedComponents: [.date])
                                .datePickerStyle(WheelDatePickerStyle())
                        }
                        
                        VStack{
                            VStack(alignment: .center) {
                            Text("Antal pling")
                                    .bold()
                                    .foregroundColor(Color.black)
                                    .underline()
                            Picker("Antalt pling", selection: $amount) {
                                ForEach(0..<101, id: \.self) { value in
                                    Text("\(value)")
                                }
                            }
                            .pickerStyle(.wheel) // You can change the style to .menu if you prefer
                        }
                    }
                        
                        VStack{
                            VStack(alignment: .center) {
                                Text("Vem var vi hos")
                                    .bold()
                                    .foregroundColor(Color.black)
                                    .underline()
                                Picker("Vem var vi hos", selection: $house) {
                                    ForEach(globalParticipantNames, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.wheel)
                            }
                        }
                    }
                    
                    TextField("Uppdatera saldo", text: $saldo)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                        
                    .padding(.horizontal)
                    
                   
                  
                    Button("Spara") {
                        let newStat = PlingStatistics(house: house, amount: amount, selectedDate: selectedDate, saldo: saldo)
                        onSave(newStat)
                        isPresented = false // Close the sheet
                        selectedDate = Date() // Clear the selected date
                        amount = 0 // Clear the amount
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: 140)
                    .padding()
                    .background(.black)
                    .cornerRadius(20)
                    .shadow(radius: 40)
                }
                .padding()
            }
            //.navigationBarTitle("Plingstatistik", displayMode: .inline)
        }
    
}

                               
                    
                    
                    

