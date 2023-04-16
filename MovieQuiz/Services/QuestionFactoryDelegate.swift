//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 13.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    // подготавливаем вопрос для
    func didRecieveNextQuestion(question: QuizQuestion?)
    
    // сообщение об успешной ошибке
    func didLoadDataFromServer()
    
    //сообщение об ошибке загрузки данных о фильмах
    func didFailToLoadData(with error: Error)
    
    // сообщение об ошибке загрузки постера
    func didFailToLoadImage(with error: Error)
    
    // отображаем лоадер
    func showLoadingIndicator()
    
    // скрываем лоадер
    func hideLoadingIndicator()
}
