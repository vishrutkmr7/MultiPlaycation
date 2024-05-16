//
//  ContentView.swift
//  MultiPlaycation
//
//  Created by Vishrut Jha on 5/15/24.
//

import SwiftUI

struct AnimalProvider {
    static let animals = ["bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog", "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo", "horse", "kangaroo", "lion", "monkey", "moose", "narwhal", "owl", "panda", "parrot", "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "thumbs", "walrus", "whale", "zebra"]
    
    static func getRandomAnimals() -> (student: String, teacher: String) {
        let shuffled = animals.shuffled()
        return (student: shuffled[0], teacher: shuffled[1])
    }
}

struct Question {
    let text: String
    let answer: Int
    
    static func generateQuestions(for range: Int, count: Int) -> [Question] {
        var questions = [Question]()
        for _ in 1...count {
            let firstNumber = Int.random(in: 2...range)
            let secondNumber = Int.random(in: 2...range)
            let questionText = "What is \(firstNumber) x \(secondNumber)?"
            let answer = firstNumber * secondNumber
            questions.append(Question(text: questionText, answer: answer))
        }
        return questions
    }
}

struct ContentView: View {
    @State private var gameIsActive = false
    @State private var questions: [Question] = []
    
    @State private var showingSettings = false
    @State private var isFirstLaunch: Bool
    
    init() {
            // Check if the app is being launched for the first time
        let firstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunched")
        _isFirstLaunch = State(initialValue: firstLaunch)
        if firstLaunch {
                // Set the first launch flag to false for subsequent launches
            UserDefaults.standard.set(true, forKey: "HasLaunched")
        }
    }

    
    var body: some View {
        ZStack {
            VStack {
                if gameIsActive {
                    let animals = AnimalProvider.getRandomAnimals()
                    GameView(
                        questions: questions,
                        studentAnimal: animals.student,
                        teacherAnimal: animals.teacher,
                        endGame: endGame
                    )
                } else {
                    SettingsView(gameIsActive: $gameIsActive, questions: $questions)
                }
            }
            
            VStack {
                HStack {
                    Spacer()
                    if !isFirstLaunch {
                        Button(action: {
                            showingSettings.toggle()
                        }) {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                }
                Spacer()
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(gameIsActive: $gameIsActive, questions: $questions)
        }
    }
    
    func endGame() {
        gameIsActive = false
        showingSettings = false
    }
}

#Preview {
    ContentView()
}
