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
    @AppStorage("blurRadius") private var blurRadius = 5.0
    
    var body: some View {
        VStack{
            Form {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkModeOn, label: {
                        Text("Dark Mode")
                    })
                    Toggle(isOn: $isBlurOn, label: {
                        Text("Blur-effect")
                    })
                    if isBlurOn {
                        HStack {
                            Text("Blur-radie:")
                            Slider(value: $blurRadius, in: 0...5, step: 0.1)
                        }
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
