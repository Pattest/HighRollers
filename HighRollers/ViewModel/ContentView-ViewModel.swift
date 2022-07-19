//
//  ContentView-ViewModel.swift
//  HighRollers
//
//  Created by Baptiste Cadoux on 19/07/2022.
//

import Foundation

extension ContentView {

    @MainActor class ViewModel: ObservableObject {
        @Published var numberOfDevices: Int = 1
        @Published var rolls = [Roll]()
        @Published var turns = [Turn]()

        func rollDices() {
            for roll in rolls {
                for _ in 0..<5 {
                    roll.timeToRoll()
                }
            }

            let turn = Turn(rolls: rolls)
            prepareRolls()
            turns.append(turn)
            saveTurns(turns)
        }

        func resetTurns() {
            turns.removeAll()
            saveTurns(turns)
        }

        func saveTurns(_ turns: [Turn]) {
            DataManager.saveTurns(turns)
        }

        func prepareRolls() {
            rolls = [
                Roll(result: -1, dice: .four)
            ]
        }

        func addRoll() {
            guard rolls.count < 5 else { return }
            let roll = Roll(result: -1, dice: .four)
            rolls.append(roll)
        }

        func removeLastRoll() {
            guard rolls.count > 1 else { return }
            rolls.removeLast()
        }
    }

}
