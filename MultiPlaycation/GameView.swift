//
//  GameView.swift
//  MultiPlaycation
//
//  Created by Vishrut Jha on 5/16/24.
//

import SwiftUI

struct BellAnimationModifier: ViewModifier {
    @State private var rotation: Double = -45
    @State private var isAnimating = false
    var delay: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation), anchor: .top)
            .animation(
                Animation.interpolatingSpring(stiffness: 50, damping: 10)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: rotation
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    rotation = 15
                    isAnimating.toggle()
                }
            }
    }
}

extension View {
    func bellAnimation(delay: Double = 0) -> some View {
        self.modifier(BellAnimationModifier(delay: delay))
    }
}

struct SmoothOscillationModifier: ViewModifier {
    @State private var rotation: Double = -15.0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotation), anchor: .bottom)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    rotation = 15.0
                }
            }
    }
}

extension View {
    func smoothOscillation() -> some View {
        self.modifier(SmoothOscillationModifier())
    }
}

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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    Image(studentAnimal)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .smoothOscillation()
                    Spacer()
                    Image(teacherAnimal)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .smoothOscillation()
                }
                .padding()
                
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
                
                VStack(alignment: .leading) {
                    Text("Game Rules:")
                        .font(.headline)
                        .padding(.bottom, 5)
                    Text("Number of turns: \(questions.count)")
                    Text("Range: Up to \(questions.first?.text.components(separatedBy: " ")[2] ?? "12")")
                }
                .padding()
                .background(Color.yellow.opacity(0.3))
                .cornerRadius(10)
                .padding()
                
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
