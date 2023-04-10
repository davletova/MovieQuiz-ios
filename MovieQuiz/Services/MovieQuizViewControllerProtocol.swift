//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 09.04.2023.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    // отображаем вопрос на основе модели
    func showQuestion(quiz: QuizStepViewModel)
    
    // показываем алерт с сообщением об окончание игры
    func showGameOverAlert()
    // показываем алерт с сообщением о неудачной загрузке постера фильма
    func showNetworkingErrorWhenImageLoad(message: String)
    // показывваем алерт с сообщением о неудачной загрузке фильмов
    func showNetworkingError(message: String)
    
    // подсвечиваем рамку постера красным или зеленым в зависимости от правильности ответа
    func highlightImageBorder(isCorrectAnswer: Bool)
    func disableImageBorder()
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
}
