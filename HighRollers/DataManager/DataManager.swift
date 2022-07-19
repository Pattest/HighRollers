//
//  DataManager.swift
//  HighRollers
//
//  Created by Baptiste Cadoux on 19/07/2022.
//

import Foundation

class DataManager {

    static let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedRolls")

    static func loadTurns() -> [Turn] {
        do {
            let data = try Data(contentsOf: savePath)
            return try JSONDecoder().decode([Turn].self, from: data)
        } catch {
            return []
        }
    }
    
    static func saveTurns(_ turns: [Turn]) {
        do {
            let data = try JSONEncoder().encode(turns)
            try data.write(to: savePath, options: [.atomic])
        } catch {
            print("Unable to save data.")
        }
    }
}
