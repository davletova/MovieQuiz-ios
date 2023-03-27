//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 12.03.2023.
//

import Foundation

struct QuizQuestion {
    let image: Data
    let text: String
    let correctAnswer: Bool
    
    init(_ image: Data, _ text: String, _ correctAnswer: Bool) {
        self.image = image
        self.text = text
        self.correctAnswer = correctAnswer
    }
}
