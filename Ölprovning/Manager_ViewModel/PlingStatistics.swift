//
//  PlingStatistics.swift
//  Ölprovning
//
//  Created by Petter Gustafsson on 2023-08-21.
//

import SwiftUI
import Foundation


struct PlingStatistics: Identifiable {
    var id = UUID()
    var house: String
    var amount: Int
    var selectedDate: Date
    var saldo: String
}
