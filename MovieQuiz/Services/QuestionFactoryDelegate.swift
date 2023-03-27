//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 13.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной ошибке
    func didFailToLoadData(with error: Error) //сообщение об ошибке загрузки данных о фильмах
    func didFailToLoadImage(with error: Error) // сообщение об ошибке загрузки постера
}
