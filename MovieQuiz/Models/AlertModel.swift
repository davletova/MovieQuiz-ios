//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 14.03.2023.
//

import Foundation

class AlertModel {
    var title: String
    var message: String
    var buttonText: String
    
    var complition: (() -> Void)? = nil
    
    init(correctAnswers: Int, questionsAmount: Int) {
        self.title = "Этот раунд окончен"
        self.message = "Ваш результат:\(correctAnswers)/\(questionsAmount)"
        self.buttonText = "Сыграть еще раз"
    }
}
