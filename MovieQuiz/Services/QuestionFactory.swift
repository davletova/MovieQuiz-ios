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
        
            let index = Int.random(in: 0..<self.movies.count)
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            // отображаем лоадер на время загрузки постера фильма
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.showLoadingIndicator()
            }
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    // прекращаем отображение лоадера
                    self.delegate?.hideLoadingIndicator()
                    // передаем ошибку, возникшую при загрузке постера
                    self.delegate?.didFailToLoadImage(with: error)
                }
                
                return
            }
            
            // прекращаем отображение лоадера
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.hideLoadingIndicator()
            }
            
            let rating = Float(movie.rating) ?? 0
            
            // рандомно выбиарем рейтинг для отображения в вопросе
            let questionRating = Int.random(in: (7...9))
            
            // рандомно выбиараем условие "больше" или "меньше" для вопроса
            // считаем, что true = "больше", false = "меньше"
            let questionSign = Bool.random()
            
            // составляем вопрос из ранее определенных условия и рейтинга
            let text = "Рейтинг этого фильма \(questionSign ? "больше" : "меньше"), чем \(questionRating)?"
            
            // определяем ответ на наш составленный вопрос
            let correctAnswer = questionSign ? rating > Float(questionRating) : rating < Float(questionRating)
            
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
