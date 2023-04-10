//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 13.03.2023.
//

import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    // подготавливаем следующий вопрос, загружаем постер фильма
    func requestNextQuestion()

    // загружаем Top-250 фильмов из IMDb
    func loadData()
}
