//
//  Turn.swift
//  HighRollers
//
//  Created by Baptiste Cadoux on 19/07/2022.
//

import Foundation

class Turn: Codable,
             Identifiable,
             ObservableObject {

    var id = UUID()
    @Published var rolls: [Roll]

    init(rolls: [Roll]) {
        self.rolls = rolls
    }

    // MARK: - Codable

    enum CodingKeys: CodingKey {
        case id
        case rolls
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(UUID.self, forKey: .id)
        self.rolls = try container.decode([Roll].self, forKey: .rolls)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(rolls, forKey: .rolls)
    }

    //

    func getTotalResult() -> Int {
        var result: Int = 0

        for roll in rolls {
            result += roll.result
        }

        return result
    }
}
