//
//  Roll.swift
//  HighRollers
//
//  Created by Baptiste Cadoux on 19/07/2022.
//

import Foundation

class Roll: Codable,
            Identifiable {

    var id = UUID()
    var result: Int
    var dice: Dice

    init(result: Int,
         dice: Dice) {
        self.result = result
        self.dice = dice
    }

    // MARK: - Codable

    enum CodingKeys: CodingKey {
        case id
        case result
        case dice
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.result = try container.decode(Int.self, forKey: .result)
        self.dice = try container.decode(Dice.self, forKey: .dice)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(result, forKey: .result)
        try container.encode(dice, forKey: .dice)
    }

    //

    func timeToRoll() {
        result = Int.random(in: 1..<dice.rawValue + 1)
    }

    func getResult() -> String {
        return result == -1 ? "?" : "\(result)"
    }
}
