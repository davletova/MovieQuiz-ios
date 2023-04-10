//
//  AlertPresenterProtocol.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 14.03.2023.
//

import Foundation

protocol AlertPresenterProtocol: AnyObject {
    // отображаем алерт на основе переданной модели
    func present(model: AlertModel)
}
