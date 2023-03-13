//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 12.03.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    private let questions: [QuizQuestion] = [
        QuizQuestion("The Godfather", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("The Dark Knight", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("Kill Bill", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("The Avengers", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("Deadpool", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("The Green Knight", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("Old", "Рейтинг этого фильма больше чем 6?", false),
        QuizQuestion("The Ice Age Adventures of Buck Wild", "Рейтинг этого фильма больше чем 6?", false),
        QuizQuestion("Tesla", "Рейтинг этого фильма больше чем 6?", false),
        QuizQuestion("Vivarium", "Рейтинг этого фильма больше чем 6?", false),
    ]
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else { return }
        
        let question = questions[safe: index]
        delegate?.didRecieveNextQuestion(question: question)
    } 
}
