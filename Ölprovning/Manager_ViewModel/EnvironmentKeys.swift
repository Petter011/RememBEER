//
//  EnvironmentKeys.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-17.
//

import SwiftUI

struct BeerViewModelKey: EnvironmentKey {
    static let defaultValue: BeerViewModel = BeerViewModel()
}

extension EnvironmentValues {
    var viewModel: BeerViewModel {
        get { self[BeerViewModelKey.self] }
        set { self[BeerViewModelKey.self] = newValue }
    }
}
