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
    var identifier: String
    
    var completion: (() -> Void)? = nil
    
    init(title: String, message: String, buttonText: String, identifier: String) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
        self.identifier = identifier
    }
}



