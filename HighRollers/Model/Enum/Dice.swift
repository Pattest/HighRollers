//
//  Dice.swift
//  HighRollers
//
//  Created by Baptiste Cadoux on 19/07/2022.
//

import Foundation
import SwiftUI

enum Dice: Int,
           Codable,
           CaseIterable {

    case four = 4
    case six = 6
    case eight = 8
    case ten = 10
    case twelve = 12
    case twenty = 20
    case hundred = 100

    var color: Color {
        switch self {
        case .four:
            return .green
        case .six:
            return .red
        case .eight:
            return .blue
        case .ten:
            return .purple
        case .twelve:
            return .gray
        case .twenty:
            return .brown
        case .hundred:
            return .orange
        }
    }
}
