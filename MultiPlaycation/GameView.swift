//
//  GameView.swift
//  MultiPlaycation
//
//  Created by Vishrut Jha on 5/16/24.
//

import SwiftUI

struct GameView: View {
    let questions: [Question]
    let studentAnimal: String
    let teacherAnimal: String
    let endGame: () -> Void
    
    @State private var questionNumber = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var showingScore = false
    
    var body: some View {
        VStack {
            Text("Score: \(score)")
                .font(.largeTitle)
                .padding()
            
            Text(questions[questionNumber].text)
                .font(.title)
                .padding()
            
            TextField("Answer", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()
            
            Button("Submit") {
                checkAnswer()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Spacer()
        }
        .padding()
        .alert(isPresented: $showingScore) {
            Alert(
                title: Text("Game Over"),
                message: Text("Your final score is \(score)"),
                dismissButton: .default(Text("OK")) {
                    endGame()
                }
            )
        }
    }
    
    func checkAnswer() {
        if let answer = Int(userAnswer), answer == questions[questionNumber].answer {
            score += 1
        }
        
        if questionNumber < questions.count - 1 {
            questionNumber += 1
        } else {
            showingScore = true
        }
        
        userAnswer = ""
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleQuestions = [
            Question(text: "What is 3 x 4?", answer: 12),
            Question(text: "What is 7 x 5?", answer: 35),
            Question(text: "What is 6 x 8?", answer: 48)
        ]
        
        GameView(questions: sampleQuestions, studentAnimal: "bear", teacherAnimal: "narwhal", endGame: {})
    }
}
