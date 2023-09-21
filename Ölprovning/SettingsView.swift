//
//  SettingsView.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-28.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkModeOn") private var isDarkModeOn = false
    @AppStorage("isBlurOn") private var isBlurOn = false
    @AppStorage("blurRadius") private var blurRadius = 10.0

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Utseende")) {
                    Toggle(isOn: $isDarkModeOn, label: {
                        Text("Mörkt läge")
                    })
                    Toggle(isOn: $isBlurOn, label: {
                        Text("Blur-effekt")
                    })
                    if isBlurOn {
                        HStack {
                            Text("Blur-radie:")
                            Slider(value: $blurRadius, in: 0...20, step: 1)
                        }
                    }
                }
            }
            .navigationTitle("Inställingar")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
