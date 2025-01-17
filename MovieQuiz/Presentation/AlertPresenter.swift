//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 14.03.2023.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPresentDelegate?
    
    init(delegate: AlertPresentDelegate? = nil) {
        self.delegate = delegate
    }
    
    func present(model: AlertModel) {
        let alert = UIAlertController(title: model.title, message: model.message, preferredStyle: .alert)
        let action = UIAlertAction(title: model.buttonText, style: .default) {_ in
            guard let complition = model.completion else { return }
            complition()
        }
        
        alert.view.accessibilityIdentifier = model.identifier
        alert.addAction(action)
        
        delegate?.present(alert: alert)
    }
}
