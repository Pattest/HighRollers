//
//  ContentView.swift
//  HighRollers
//
//  Created by Baptiste Cadoux on 18/07/2022.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Text("High Rollers")
                    .font(.largeTitle)
                
                Stepper("Number of dices: \(viewModel.rolls.count)/5",
                        onIncrement: {
                    viewModel.addRoll()
                }, onDecrement: {
                    viewModel.removeLastRoll()
                })
                .allowsHitTesting(viewModel.timerIsPaused)
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.rolls, id: \.id) { roll in
                            ZStack {
                                Text("\(roll.getResult())")
                                    .font(.largeTitle)
                                Text("D\(roll.dice.rawValue)")
                                    .font(.caption)
                                    .position(.zero)
                            }
                            .font(.largeTitle)
                            .padding()
                            .frame(width: 120, height: 120)
                            .background(roll.dice.color)
                            .cornerRadius(10)
                            .contextMenu {
                                ForEach(0..<Dice.allCases.count, id: \.self) { indexDice in
                                    let newDice = Dice.allCases[indexDice]
                                    Button("D\(newDice.rawValue)") {
                                        viewModel.updateDiceRoll(roll, with: newDice)
                                    }
                                }
                            }
                        }
                    }
                }
                
                Button("Roll dice(s)") {
                    viewModel.rollDices()
                }
                .allowsHitTesting(viewModel.timerIsPaused)
            }
            .padding()
            
            List(viewModel.turns.reversed(), id: \.id) { turn in
                let index = viewModel.turns.firstIndex(where: { $0.id == turn.id })!
                
                Section("Turn \(index + 1)") {
                    Text("Total: \(turn.getTotalResult())")
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(turn.rolls, id: \.id) { roll in
                                ZStack {
                                    Text("\(roll.getResult())")
                                        .font(.largeTitle)
                                    Text("D\(roll.dice.rawValue)")
                                        .font(.caption)
                                        .position(.zero)
                                }
                                .padding()
                                .frame(width: 100, height: 100)
                                .background(roll.dice.color)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            
            Button("Reset turn list") {
                viewModel.resetTurns()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
