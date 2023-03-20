//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 13.03.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didRecieveNextQuestion(question: QuizQuestion?)
}
