//
//  ParticipantManager.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-09-05.
//

import Foundation

class ParticipantManager: ObservableObject {
    @Published var globalParticipantNames: [String] = UserDefaults.standard.stringArray(forKey: "participantNames") ?? []

    func addParticipant(_ participant: String) {
        globalParticipantNames.append(participant)
        saveParticipantNames()
    }

    func deleteParticipant(at index: Int) {
        globalParticipantNames.remove(at: index)
        saveParticipantNames()
    }

    private func saveParticipantNames() {
        UserDefaults.standard.set(globalParticipantNames, forKey: "participantNames")
    }
}
