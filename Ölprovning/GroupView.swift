//
//  CreateGroupView.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-28.
//

import SwiftUI

struct GroupView: View {
    @State private var showingCreateGroupView = false
    @State private var showingParticipantsView = false
    @State private var showingJoinGroupView = false
    @State private var participants: [String] = []
    @State private var globalParticipantNames: [String] = UserDefaults.standard.stringArray(forKey: "participantNames") ?? []

    
    
    var body: some View {
        NavigationStack{
            ZStack{
                Image("BackgroundImageBeer")
                    .resizable()
                //.aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.top)
                
                
                HStack{
                    Button(action: {
                        showingParticipantsView .toggle()
                    }) {
                        Text("Deltagare")
                            .padding()
                            .frame(maxWidth: 120, maxHeight: 40)
                            .foregroundColor(.black)
                            .background(Color.orange)
                            .cornerRadius(15)
                            .font(.title3)
                            .shadow(radius: 40)
                    }
                    .padding(.bottom, 20)
                    .sheet(isPresented: $showingParticipantsView) {
                        ParticipantsView(isPresented: $showingParticipantsView, globalParticipantNames: $globalParticipantNames)
                    }


                    .padding()
                    
                    Button(action: {
                        showingJoinGroupView.toggle()
                    }) {
                        Text("Gå med")
                            .padding()
                            .frame(maxWidth: 120, maxHeight: 40)
                            .foregroundColor(.black)
                            .background(Color.orange)
                            .cornerRadius(15)
                            .font(.title3)
                            .shadow(radius: 40)
                    }
                    .padding(.bottom, 20)
                    .sheet(isPresented: $showingJoinGroupView){
                        JoinGroupView()
                        }
                    
                    
                }
            }
            .navigationTitle("Grupper")
        }
    }
}
