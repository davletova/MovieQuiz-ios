//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 18.03.2023.
//

import Foundation

class GameRecord: Codable {
    // количество правильных ответов
    let correct: Int
    // количество вопросов в квизе
    let total: Int
    // дата прохождения квиза
    let date: Date
    
    init(correct: Int, total: Int, date: Date) {
        self.correct = correct
        self.total = total
        self.date = date
    }
}
