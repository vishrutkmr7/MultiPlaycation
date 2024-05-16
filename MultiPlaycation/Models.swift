//
//  Models.swift
//  MultiPlaycation
//
//  Created by Vishrut Jha on 5/16/24.
//

import Foundation

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
