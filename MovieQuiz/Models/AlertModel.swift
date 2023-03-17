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
    
    var complition: (() -> Void)? = nil
    
    init(title: String, message: String, buttonText: String) {
        self.title = title
        self.message = message
        self.buttonText = buttonText
    }
}



