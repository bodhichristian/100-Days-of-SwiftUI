//
//  DiceRollView.swift
//  HighRollers
//
//  Created by christian on 11/21/22.
//

import SwiftUI

struct DiceRollView: View {
    //options for number sides on the rolled dice
    let diceTypes = [4, 6, 8, 10, 12, 20, 100]
    
    //default selections for Picker and Stepper
    @AppStorage("selectedDiceType") var selectedDiceType = 6
    @AppStorage("numberToRoll") var numberToRoll = 4
    
    @State private var currentResult = DiceResult(type: 0, number: 0)
    
    //storage location for previous dice rolls
    let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedRolls.json")
    @State private var savedResults = [DiceResult]()
    
    //columns for LazyVGrid that contains dice roll results
    let columns: [GridItem] = [
        .init(.adaptive(minimum: 60))
    ]
    
    //timer for animating the dice roll
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var stoppedDice = 0
    
    //creating an instance of the .rigid haptic pattern
    @State private var feedback = UIImpactFeedbackGenerator(style: .rigid)
    
    //detects if VoiceOver is enabled
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Type of dice", selection: $selectedDiceType) {
                        ForEach(diceTypes, id: \.self) { type in
                            Text("D\(type)")
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Stepper("Number of dice: \(numberToRoll)", value: $numberToRoll, in: 1...20)
                    
                    Button("Roll em!", action: rollDice)
                } footer: {
                    LazyVGrid(columns: columns) {
                        ForEach(0..<currentResult.rolls.count, id: \.self) { rollNumber in
                            Text(String(currentResult.rolls[rollNumber]))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                                .foregroundColor(.black)
                                .background(.white)
                                .cornerRadius(10)
                                .shadow(color: .primary, radius: 4)
                                .font(.title)
                                .padding(5)
                            //accessibility modifiers
                            //groups grid of current rolls for easier reading with VoiceOver
                                .accessibilityElement()
                                .accessibilityLabel("Latest roll: \(currentResult.description)")
                        }
                    }
                }
                .disabled(stoppedDice < currentResult.rolls.count)
                
                Section("Previous results") {
                    ForEach(savedResults) { result in
                        HStack {
                            Text("🎲")
                                .font(.title)
                            VStack(alignment: .leading) {
                                Text("\(result.number) rolls of D\(result.type)")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                Text(result.description)
                            }
                            //accessibility modifiers
                            //previous results are grouped for easier reading with VoiceOver
                            .accessibilityElement()
                            .accessibilityLabel("\(result.number) D\(result.type), \(result.description)")
                        }
                    }
                }
            }
            .navigationTitle("HighRollers")
            
            .onReceive(timer) { data in
                updateDice()
            }
        }
        .onAppear(perform: load)
    }
    
    func rollDice() {
        currentResult = DiceResult(type: selectedDiceType, number: numberToRoll)
        
        //bypasses the animation of dice rolling if VoiceOver is enabled
        if voiceOverEnabled {
            stoppedDice = numberToRoll
            savedResults.insert(currentResult, at: 0)
            save()
        }
        stoppedDice = -20
    }
    
    //1. check if all dice rolls have already stopped
    //2. count from the value of stoppedDice up to numberToRoll, giving each a random number
    //3. add 1 to stoppedDice to lock in its current value and stop another die
    //4. when all dice stop rolling, save results
    func updateDice() {
        guard stoppedDice < currentResult.rolls.count else { return }
        
        for i in stoppedDice..<numberToRoll {
            if i < 0 { continue }
            currentResult.rolls[i] = Int.random(in: 1...selectedDiceType)
            //trigger haptic feedback
            feedback.impactOccurred()
        }
        
        stoppedDice += 1
        
        if stoppedDice == numberToRoll {
            savedResults.insert(currentResult, at: 0)
            save()
        }
        
    }
    
    func load() {
        if let data = try? Data(contentsOf: savePath) {
            if let results = try? JSONDecoder().decode([DiceResult].self, from: data) {
                savedResults = results
            }
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(savedResults) {
            try? data.write(to: savePath, options: [.atomic, .completeFileProtection])
        }
    }
}

struct DiceRollView_Previews: PreviewProvider {
    static var previews: some View {
        DiceRollView()
    }
}
