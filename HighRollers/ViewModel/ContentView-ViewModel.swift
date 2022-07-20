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

        private var timer: Timer?
        var timerIsPaused: Bool = true

        @Published var rolls = [Roll]()
        @Published var turns = [Turn]()

        @Published private var engine: CHHapticEngine?

        init() {
            turns = DataManager.loadTurns()

            prepareRolls()
            prepareHaptics()
        }

        func rollDices() {
            var count = 0

            timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { resultTimer in
                for roll in self.rolls {
                    self.objectWillChange.send()
                    roll.timeToRoll()
                }

                count += 1

                if count == 5 {
                    resultTimer.invalidate()
                    self.rollsAreDone()
                    self.timerIsPaused = true
                }
            }
        }

        func rollsAreDone() {
            playHaptics()

            //
            let turn = Turn(rolls: rolls)
            turns.append(turn)
            saveTurns(turns)

            // Flush rolls
            prepareRolls()
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

        func updateDiceRoll(_ roll: Roll, with newDice: Dice) {
            objectWillChange.send()
            roll.dice = newDice
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
