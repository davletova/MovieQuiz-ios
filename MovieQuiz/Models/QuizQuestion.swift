//
//  QuizQuestion.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 12.03.2023.
//

import Foundation

struct QuizQuestion {
    let image: String
    let text: String
    let correctAnswer: Bool
    
    init(_ image: String, _ text: String, _ correctAnswer: Bool) {
        self.image = image
        self.text = text
        self.correctAnswer = correctAnswer
    }
}
