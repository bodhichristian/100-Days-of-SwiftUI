//
//  ContentView.swift
//  WordScramble
//
//  Created by christian on 8/12/22.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var score = 0
    @State private var wordsPlayed = 0
    
    
    
    var body: some View {
        NavigationView {
            List {
                VStack(alignment: .leading) {
                    Text("""
                         ☞ Find words that can be created using letters from the word below.
                         ☞ Words must have at least 3 letters.
                         ☞ You may not play the generated word.
                         ☞ You may not use the same word twice.
                         """)
                    .multilineTextAlignment(.leading)
                    .font(.subheadline)
                    
                    .padding(4)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text(rootWord)
                            .font(.title).fontWeight(.heavy)
                            .foregroundColor(.cyan)
                            .padding(10)
                        Spacer()
                    }
                    TextField("Enter your word:", text: $newWord)
                        .autocapitalization(.none)
                        .multilineTextAlignment(.center)
                    
                    HStack{
                        Text("Your Score: ")
                            .font(.headline)
                        Text("\(score)")
                        Spacer()
                        Text("Words Played: ")
                            .font(.headline)
                        Text("\(wordsPlayed)")
                    }
                    HStack{
                        Spacer()
                        Button("Next Word", action: startGame)
                            .foregroundColor(.cyan)
                        Spacer()
                        
                    }
                    
                }
                
                Text("Used Words")
                    .font(.subheadline)
                ScrollView {
                    ForEach(usedWords, id: \.self) { word in
                        HStack{
                            Image(systemName: "\(word.count).circle")
                                .renderingMode(.original)
                                .foregroundColor(.cyan)
                            Text(word)
                            Spacer()
                        }
                        .accessibilityElement()
                        .accessibilityLabel(word)
                        .accessibilityHint("\(word.count) letters")
                    }
                }
            }
            
            
            .navigationTitle("WordScramble")
//            .toolbar {
//                Button("Reset", action: startGame)
//                    .foregroundColor(.cyan)
//            }
            .onSubmit(addNewWord)
            .onAppear(perform: startGame)
            .alert(errorTitle, isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    func addNewWord() {
        //creates a new word from the user's guess, lowercases, and removes whitespaces and newlines
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        //if answer contains no characters, do nothing
        guard answer.count > 0 else { return }
        
        guard isLongEnough(word: answer) else {
            wordError(title: "Word is not long enough", message: "You must use at least 3 characters")
            return
        }
        
        guard isNotRoot(word: answer) else {
            wordError(title: "That's the root word", message: "You may not use the root word.")
            return
        }
        
        //if word is not real, present error
        guard isReal(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't make them up you know!")
            return
        }
        
        //if word can't be made from rootWord, present error
        guard isPossible(word: answer) else {
            wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'")
            return
        }
        
        //if word has already been played, present error
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original!")
            return
        }
        withAnimation {
            usedWords.insert(answer, at: 0)
            newWord = ""
        }
        score += answer.count
        wordsPlayed += 1
    }
    
    
    func startGame() {
        usedWords = [String]()
        score = 0
        wordsPlayed = 0
        //searches app bundle for start.txt url and assigns that value to startWordsURL
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            //if successful, creates a string with the contents of startWordsURL
            
            if let startWords = try? String(contentsOf: startWordsURL) {
                //if successful, separates that string by line breaks, creates an array allWords
                let allWords = startWords.components(separatedBy: "\n")
                //assigns rootWord a value of a ranodm element from allWords, nil coalescing with silkworm
                rootWord = allWords.randomElement() ?? "silkworm"
                //exits
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    //method that takes a string and returns a bool
    func isPossible(word: String) -> Bool {
        //creates a copy of rootWord
        var tempWord = rootWord
        //iterates over each letter checking if it is included in the root word, and if it is, removes that letter so that it can't be guessed against twice
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        return true
    }
    
    //method that takes a string and returns a bool
    func isReal(word: String) -> Bool {
        //creates an instance of UITextCheckerd
        let checker = UITextChecker()
        //creates a range from for the number of letters contained in the word
        let range = NSRange(location: 0, length: word.utf16.count)
        //creates a range in which a misspelled word may appear
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        //if that range includes no spelling errors, isReal returns true
        return misspelledRange.location == NSNotFound
    }
    
    //tests length for minimum
    func isLongEnough(word: String) -> Bool {
        if word.count > 2 {
            return true
        } else {
            return false
        }
    }
    
    func isNotRoot(word: String) -> Bool {
        if word != rootWord {
            return true
        } else {
            return false
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
