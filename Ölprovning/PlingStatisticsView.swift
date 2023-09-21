//
//  PlingStatistics.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-21.
//

import SwiftUI

struct PlingStatisticsView: View {
    
    @State private var showingAddPlingStatisticsView = false
    @State private var plings:[PlingStatistics] = []
    @State private var isButtonTapped = false
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 10.0
    @State private var isFirstStatisticAdded = UserDefaults.standard.bool(forKey: "isFirstStatisticAdded")


    
    
    
    private var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd/MM-yyyy" // Customize the date format as needed
           return formatter
       }()
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("BackgroundImageBeer")
                    .resizable()
                    //.aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.top)
                    .blur(radius: isBlurOn ? CGFloat(blurRadius) : 0)
                
                VStack(spacing: 20) {
                    ScrollView {
                        ForEach(plings.reversed()) { stat in
                            VStack {
                                Text(stat.selectedDate, formatter: dateFormatter)
                                    .font(.title2)
                                    .foregroundColor(.orange)
                                Spacer()
                                Text(stat.house)
                                    .font(.title3)
                                    .foregroundColor(.orange)
                                Text("Pling: \(stat.amount)")
                                    .font(.title3)
                                    .foregroundColor(.orange)
                                Text("Saldo: \(stat.saldo) kr")
                                    .font(.title3)
                                    .foregroundColor(.orange)
                            }
                            .padding()
                            .frame(maxWidth: 250)
                            .foregroundColor(.white)
                            .background(Color.black)
                            .cornerRadius(25)
                            .shadow(radius: 5)
                        }
                    }
                    .padding(.top, 20)
                    
                    Spacer()
                    
                    Button(action: {
                        showingAddPlingStatisticsView.toggle()
                        
                    }) {
                        Text("Lägg till")
                            .padding()
                            .frame(maxWidth: 120, maxHeight: 40)
                            .foregroundColor(.black)
                            .background(Color.orange)
                            .cornerRadius(15)
                            .font(.title3)
                            .shadow(radius: 40)
                    }
                    .offset(x: isButtonTapped ? -5 : 0, y: 0)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                            isButtonTapped.toggle()
                        }
                    }
                    .padding(.bottom, 20)
                    
                    .sheet(isPresented: $showingAddPlingStatisticsView) {
                        AddPlingStatisticsView(onSave: { newStat in
                            plings.append(newStat)
                        }, isPresented: $showingAddPlingStatisticsView)
                    }
                }
            }
            .navigationTitle("Spelstatistik")
            .onAppear {
                dateFormatter.dateFormat = "dd/MM-yyyy"
            }
        }
    }
}
struct PlingStatistics_Previews: PreviewProvider {
    static var previews: some View {
        PlingStatisticsView()
    }
}
