//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 14.03.2023.
//

import UIKit

protocol AlertPresentDelegate: AnyObject {
    // показываем алерт
    func present(alert: UIAlertController)
}
