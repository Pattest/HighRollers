//
//  ContentView-ViewModel.swift
//  HighRollers
//
//  Created by Baptiste Cadoux on 19/07/2022.
//

import Foundation
import CoreHaptics

extension ContentView {

    @MainActor class ViewModel: ObservableObject {
        @Published var numberOfDevices: Int = 1
        @Published var rolls = [Roll]()
        @Published var turns = [Turn]()

        @Published private var engine: CHHapticEngine?

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
            playHaptics()
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
        // MARK: - Haptics

        func prepareHaptics() {
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

            do {
                engine = try CHHapticEngine()
                try engine?.start()
            } catch {
                print("There was an error creating the engine: \(error.localizedDescription)")
            }
        }

        func playHaptics() {
            // make sure that the device supports haptics
            guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
            var events = [CHHapticEvent]()

            // create one intense, sharp tap
            for i in stride(from: 0, to: 1, by: 0.1) {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
                events.append(event)
            }

            for i in stride(from: 0, to: 1, by: 0.1) {
                let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
                let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
                let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
                events.append(event)
            }

            // convert those events into a pattern and play it immediately
            do {
                let pattern = try CHHapticPattern(events: events, parameters: [])
                let player = try engine?.makePlayer(with: pattern)
                try player?.start(atTime: 0)
            } catch {
                print("Failed to play pattern: \(error.localizedDescription).")
            }
        }
    }

}
