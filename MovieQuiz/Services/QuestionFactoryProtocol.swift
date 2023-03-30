//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 13.03.2023.
//

import Foundation

protocol QuestionFactoryProtocol: AnyObject {
    func requestNextQuestion()
    func loadData()
}
