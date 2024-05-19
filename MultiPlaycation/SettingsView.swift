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
    @Binding var selectedTable: Int
    @Binding var numberOfQuestions: Int
    @Binding var studentAnimal: String
    @Binding var teacherAnimal: String
    @Binding var showingSettings: Bool
    
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                let animalSize: CGFloat = 50
                let numberOfAnimals = AnimalProvider.animals.count
                
                let borderAnimals = numberOfAnimals / 2
                let inwardAnimals = numberOfAnimals - borderAnimals
                
                let positions = calculateAnimalPositions(
                    in: geometry.size,
                    borderAnimals: borderAnimals,
                    inwardAnimals: inwardAnimals,
                    animalSize: animalSize
                )
                
                ForEach(0..<positions.count, id: \.self) { index in
                    let position = positions[index]
                    let animal = AnimalProvider.animals[index]
                    
                    Image(animal)
                        .resizable()
                        .frame(width: animalSize, height: animalSize)
                        .position(position)
//                        .opacity(0.8)
                }
            }
            .ignoresSafeArea()
            
            VStack {
                Capsule()
                    .fill(Color.gray)
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                Spacer()
            }
            
            VStack(spacing: 20) {
                Text("Choose your settings for the game")
                    .font(.headline)
                    .padding(.top, 20)
                
                Stepper("Up to: \(selectedTable) times table", value: $selectedTable, in: 2...12)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                
                Stepper("Number of questions: \(numberOfQuestions)", value: $numberOfQuestions, in: 5...20)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.5))
                    .cornerRadius(10)
                
                Button(action: {
                    questions = Question.generateQuestions(for: selectedTable, count: numberOfQuestions)
                    gameIsActive = true
                    let animals = AnimalProvider.getRandomAnimals()
                    studentAnimal = animals.student
                    teacherAnimal = animals.teacher
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    showingSettings = false
                }) {
                    Text("Start Game")
                        .frame(maxWidth: .infinity, maxHeight: 44)
                        .background(.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(.thinMaterial)
            .cornerRadius(20)
            .padding()
        }
    }
    
    func calculateAnimalPositions(in size: CGSize, borderAnimals: Int, inwardAnimals: Int, animalSize: CGFloat) -> [CGPoint] {
        var positions = [CGPoint]()
        
        let centerX = size.width / 2
        let centerY = size.height / 2
        let radius: CGFloat = min(centerX, centerY) - animalSize
        let angleIncrement = 2 * .pi / CGFloat(borderAnimals)
        
        for i in 0..<borderAnimals {
            let angle = CGFloat(i) * angleIncrement
            let x = centerX + radius * cos(angle)
            let y = centerY + radius * sin(angle)
            positions.append(CGPoint(x: x, y: y))
        }
        
        let centerRectWidth: CGFloat = size.width * 0.6
        let centerRectHeight: CGFloat = size.height * 0.6
        let centerRect = CGRect(
            x: centerX - centerRectWidth / 2,
            y: centerY - centerRectHeight / 2,
            width: centerRectWidth,
            height: centerRectHeight
        )
        
        var remainingAnimals = inwardAnimals
        var attempts = 0
        while remainingAnimals > 0 && attempts < 1000 {
            let x = CGFloat.random(in: animalSize / 2...(size.width - animalSize / 2))
            let y = CGFloat.random(in: animalSize / 2...(size.height - animalSize / 2))
            let point = CGPoint(x: x, y: y)
            
            if !centerRect.contains(point) && !positions.contains(where: { $0.distance(to: point) < animalSize + 10 }) {
                positions.append(point)
                remainingAnimals -= 1
            }
            
            attempts += 1
        }
        
        return positions
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        let dx = x - point.x
        let dy = y - point.y
        return sqrt(dx * dx + dy * dy)
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
            ]),
            selectedTable: .constant(10),
            numberOfQuestions: .constant(3),
            studentAnimal: .constant("bear"),
            teacherAnimal: .constant("narwhal"),
            showingSettings: .constant(true)
        )
    }
}
