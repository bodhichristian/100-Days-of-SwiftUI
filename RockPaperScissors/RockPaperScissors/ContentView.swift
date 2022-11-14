//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by christian on 8/3/22.
//

import SwiftUI

struct ContentView: View {
    @State private var cpuMove = Int.random(in: 0..<3)
    @State private var shouldWin = Bool.random()
    @State private var round = 1
    @State private var score = 0
    @State private var showingResults = false
    
    let moves = ["🪨", "📄", "✂️"]
    let winningMoves = ["📄", "✂️", "🪨"]
    
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors:[.secondary, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Spacer()
                Text("rock, paper, scissors")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .shadow(radius: 5)
                
                
                Text("\(moves[cpuMove])")
                    .font(.system(size: 200))
                    .frame(width: 300, height: 300)
                    .padding(.vertical, 20)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                    .padding(5)
                
                Text("round: \(round) of 10")
                    .font(.title2)
                    .foregroundStyle(.black)
                    .padding(2)
                
                Text(shouldWin ? "select the winning move:" : "select the losing move:")
                    .font(.system(size: 26))
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                
                
                
                
                
                
                HStack(spacing: 40) {
                    ForEach(0..<3) { move in
                        Button {
                            selectMove(move)
                            
                        } label: {
                            Text("\(moves[move])")
                                .font(.system(size: 80))
                                .padding(2)
                            
                            
                        }
                    }
                    
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
                
                Spacer()
                
                Text("your score: \(score)")
                    .font(.system(size: 26))
                    .foregroundStyle(.black)
                
                Spacer()
            }
            .alert("Game over", isPresented: $showingResults) {
                Button("Play Again", action: reset)
            } message: {
                Text("You scored \(score) out of 10")
            }
        
        }
    }
    
    func selectMove(_ choice: Int) {
        let winningMoves = [1, 2, 0]
        let didWin: Bool
        
        if shouldWin {
            didWin = choice == winningMoves[cpuMove]
        } else {
            didWin = winningMoves[choice] == cpuMove
        }
        
        if didWin {
            score += 1
        }
        
        if round == 10 {
            showingResults = true
        } else {
            shouldWin.toggle()
            cpuMove = Int.random(in: 0..<3)
            round += 1
        }
    }
    
    func reset() {
        cpuMove = Int.random(in: 0..<3)
        shouldWin = Bool.random()
        round = 0
        score = 0
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


//Each turn of the game the app will randomly pick either rock, paper, or scissors.
//Each turn the app will alternate between prompting the player to win or lose.
//The player must then tap the correct move to win or lose the game.
//If they are correct they score a point; otherwise they lose a point.
//The game ends after 10 questions, at which point their score is shown.
//So, if the app chose “Rock” and “Win” the player would need to choose “Paper”, but if the app chose “Rock” and “Lose” the player would need to choose “Scissors”.
//
//Hacking with Swift+ subscribers can get a complete video solution for this checkpoint here: Solution to Rock, Paper, Scissors. If you don’t already subscribe, you can start a free trial today.
//To solve this challenge you’ll need to draw on skills you learned in tutorials 1 and 2:
//
//Start with an App template, then create a property to store the three possible moves: rock, paper, and scissors.
//You’ll need to create two @State properties to store the app’s current choice and whether the player should win or lose.
//You can use Int.random(in:) to select a random move. You can use it for whether the player should win too if you want, but there’s an even easier choice: Bool.random() is randomly true or false. After the initial value, use toggle() between rounds so it’s always changing.
//Create a VStack showing the player’s score, the app’s move, and whether the player should win or lose. You can use if shouldWin to return one of two different text views.
//The important part is making three buttons that respond to the player’s move: Rock, Paper, or Scissors.
//Use the font() modifier to adjust the size of your text. If you’re using emoji for the three moves, they also scale. Tip: You can ask for very large system fonts using .font(.system(size: 200)) – they’ll be a fixed size, but at least you can make sure they are nice and big!
