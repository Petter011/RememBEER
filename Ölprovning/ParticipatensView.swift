//
//  Participatens.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-09-04.
//
import SwiftUI

struct ParticipantsView: View {
    @Binding var isPresented: Bool
    @Binding var globalParticipantNames: [String]
    @State private var newParticipantName = ""
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Namn", text: $newParticipantName)
                    .textFieldStyle(.roundedBorder)
                    .padding(.top, 20)

                Button("Lägg till") {
                    addParticipant()
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.orange)
                .frame(maxWidth: 100, maxHeight: 40)
                .cornerRadius(15)
                .shadow(radius: 5)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding(.top, 10)
                }

                List {
                    ForEach(globalParticipantNames, id: \.self) { participant in
                        Text(participant)
                            .onTapGesture {
                                // Handle tapping on a name (e.g., show an edit view)
                            }
                    }
                    .onDelete(perform: deleteParticipants)
                }
            }
            .navigationBarTitle("Lägg till Delatagare")
            .navigationBarItems(trailing:
                Button("Klar") {
                    isPresented = false
                }
                .foregroundColor(.orange)
            )
        }
    }

    func addParticipant() {
        if !newParticipantName.isEmpty && !globalParticipantNames.contains(newParticipantName) {
            globalParticipantNames.append(newParticipantName)
            newParticipantName = ""
            UserDefaults.standard.set(globalParticipantNames, forKey: "participantNames")
            errorMessage = "" // Clear the error message
        } else {
            errorMessage = "Namnet finns redan" // Set the error message
        }
    }

    func deleteParticipants(at offsets: IndexSet) {
        globalParticipantNames.remove(atOffsets: offsets)
        UserDefaults.standard.set(globalParticipantNames, forKey: "participantNames")
    }
}
