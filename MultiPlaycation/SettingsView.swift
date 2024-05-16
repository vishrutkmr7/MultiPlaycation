//
//  SettingsView.swift
//  MultiPlaycation
//
//  Created by Vishrut Jha on 5/16/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var gameIsActive: Bool
    @Binding var questions: [Question]
    @State private var selectedTable = 12
    @State private var numberOfQuestions = 10
    
    var body: some View {
        VStack {
            Text("Choose your settings for the game")
                .font(.headline)
                .padding()
            
            Stepper("Up to: \(selectedTable) times table", value: $selectedTable, in: 2...12)
            Stepper("Number of questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 5...20)
            
            Button("Start Game") {
                questions = Question.generateQuestions(for: selectedTable, count: numberOfQuestions)
                gameIsActive = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(
            gameIsActive: .constant(false),
            questions: .constant([
                Question(text: "What is 2 x 3?", answer: 6),
                Question(text: "What is 4 x 5?", answer: 20),
                Question(text: "What is 6 x 7?", answer: 42)
            ])
        )
    }
}