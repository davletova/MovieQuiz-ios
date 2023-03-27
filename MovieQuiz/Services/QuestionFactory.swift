//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 12.03.2023.
//

import Foundation

class QuestionFactory: QuestionFactoryProtocol {

    private var movies: [MostPopularMovie] = []
    
    private let moviesLoader: MoviesLoading
    
    weak var delegate: QuestionFactoryDelegate?
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
        
            let index = (0..<self.movies.count).randomElement() ?? 0
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.delegate?.didFailToLoadImage(with: error)
                }
                
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            let questionRating = (6...9).randomElement() ?? 0
            let text = "Рейтинг этого фильма больше, чем \(questionRating)?"
            let correctAnswer = rating > Float(questionRating)
            
            let question = QuizQuestion(imageData, text, correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
}
