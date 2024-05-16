//
//  ContentView.swift
//  MultiPlaycation
//
//  Created by Vishrut Jha on 5/15/24.
//

import SwiftUI

struct ContentView: View {
    @State private var gameIsActive = true
    @State private var questions: [Question] = Question.generateQuestions(for: 12, count: 10)
    @State private var showingSettings = false
    @State private var isFirstLaunch: Bool
    @State private var selectedTable = 12
    @State private var numberOfQuestions = 10
    @State private var studentAnimal = "bear"
    @State private var teacherAnimal = "narwhal"
    
    init() {
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
                    GameView(
                        questions: questions,
                        studentAnimal: studentAnimal,
                        teacherAnimal: teacherAnimal,
                        endGame: endGame
                    )
                }
            }
            
            VStack {
                HStack {
                    Spacer()
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
                Spacer()
            }
        }
        .sheet(isPresented: $showingSettings, onDismiss: applySettings) {
            SettingsView(
                gameIsActive: $gameIsActive,
                questions: $questions,
                selectedTable: $selectedTable,
                numberOfQuestions: $numberOfQuestions,
                studentAnimal: $studentAnimal,
                teacherAnimal: $teacherAnimal,
                showingSettings: $showingSettings
            )
        }
    }
    
    func endGame() {
        gameIsActive = false
    }
    
    func applySettings() {
        questions = Question.generateQuestions(for: selectedTable, count: numberOfQuestions)
        gameIsActive = true
    }
}

#Preview {
    ContentView()
}
