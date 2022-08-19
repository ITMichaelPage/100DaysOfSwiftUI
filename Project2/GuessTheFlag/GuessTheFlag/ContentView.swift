//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Michael Page on 11/8/2022.
//

import SwiftUI

struct FlagImage: View {
    let country: String
    
    var body: some View {
        Image(country)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
}

struct ProminentTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.largeTitle)
            .foregroundColor(Color(red: 220/255, green: 232/255, blue: 245/255))
    }
}

extension View {
    func prominentTitled() -> some View {
        modifier(ProminentTitle())
    }
}

struct ContentView: View {
    @State private var showingScoreAlert = false
    @State private var scoreAlertTitle = ""
    @State private var scoreAlertMessage = ""
    @State private var showingEndOfGameAlert = false
    @State private var currentScore = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var currentRound = 1
    @State private var animationAmount = 0.0
    @State private var selectedFlagNumber: Int? = nil
    @State private var aFlagWasTapped: Bool = false

    private var roundsPerGame = 8

    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            self.aFlagWasTapped = true
                            self.selectedFlagNumber = number
                            withAnimation(
                                .interpolatingSpring(stiffness: 30, damping: 8)
                            ) {
                                self.animationAmount += 360
                            }
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .rotation3DEffect(.degrees(self.selectedFlagNumber == number ? self.animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(self.aFlagWasTapped && self.selectedFlagNumber != number ? 0.25 : 1.0)
                        .scaleEffect(self.aFlagWasTapped && self.selectedFlagNumber != number ? 0.8 : 1.0)
                        .animation(.easeInOut(duration: 0.5), value: self.aFlagWasTapped)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                HStack(spacing: 26) {
                    Text("Score: \(currentScore)")
                    Text("Round: \(currentRound)/\(roundsPerGame)")
                }
                .prominentTitled()
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreAlertTitle, isPresented: $showingScoreAlert) {
            Button("Continue", action: newRound)
        } message: {
            Text(scoreAlertMessage)
        }
        .alert("Score Summary", isPresented: $showingEndOfGameAlert) {
            Button("Start New Game", action: resetGame)
        } message: {
            Text("You guessed \(currentScore) out of \(roundsPerGame) correct!")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            currentScore += 1
            scoreAlertTitle = "Correct"
            scoreAlertMessage = "Your score is \(currentScore)."
        } else {
            scoreAlertTitle = "Wrong"
            scoreAlertMessage = "That's the flag of \(countries[number])."
        }
        
        if currentRound >= roundsPerGame {
            showingEndOfGameAlert = true
        } else {
            showingScoreAlert = true
        }
    }
    
    func shuffleFlagsAndSelectAnswer() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlagNumber = nil
    }
    
    func resetGame() {
        shuffleFlagsAndSelectAnswer()
        currentScore = 0
        currentRound = 1
    }
    
    func newRound() {
        shuffleFlagsAndSelectAnswer()
        currentRound += 1
        aFlagWasTapped = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
