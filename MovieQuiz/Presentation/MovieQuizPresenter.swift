//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 08.04.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter {
    private var currentQuestionIndex: Int = 0
    private let questionsAmount: Int = 10
    private var correctAnswers: Int = 0
    
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private weak var viewController: MovieQuizViewControllerProtocol?
    private var statisticService: StatisticService?
    
    init(viewController: MovieQuizViewControllerProtocol, statisticService: StatisticService) {
        self.viewController = viewController
        self.statisticService = statisticService
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // проверяем какой это впорос по счету
    // если последний, то показываем алерт о завершении игры
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion() {
            viewController?.showGameOverAlert()
        } else {
            switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    // в зависимости от того, правильный ответ или нет, увеличиваем счетчик correctAnswers и окрашиваем границы постера
    private func proceedWithAnswer(isCorrect: Bool) {
        correctAnswers = isCorrect ? correctAnswers : correctAnswers + 1
        
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // убираем зеленую или красную рамку после предыдущего ответа
            guard let self = self else { return }
            
            self.viewController?.disableImageBorder()
            self.proceedToNextQuestionOrResults()
        }
    }
    
    func requestNextQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    func loadData() {
        questionFactory?.loadData()
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
        
    func didAnswer(isYes: Bool) {
        if let currentQuestion = currentQuestion {
            proceedWithAnswer(isCorrect: isYes == currentQuestion.correctAnswer)
        }
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            QuestionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // генерируем соощения со статистикой игр
    func makeResultMessage() -> String {
        statisticService?.store(correct: correctAnswers, total: questionsAmount)
        
        // пытаемся достать количество сыгранных квизов
        // если не получается, то считаем, что количество сыгранных квизов = 1
        var gamesCount = 1
        if let gamesCountFromStore = statisticService?.gamesCount {
            gamesCount = gamesCountFromStore
        }
        
        // пытаемся достать точность ответов за все игры
        // если не получается, то вычисляем точность на основе последней игры
        var totalAccuracy: Double = Double(correctAnswers / questionsAmount * 100)
        if let totalAccuracyFromStore = statisticService?.totalAccuracy {
            totalAccuracy =  totalAccuracyFromStore
        }
       
        // пытаемся достать лучшую игру
        // если не получается, то считаем, что лучшая игра - текущая
        var bestGame = GameRecord(correct: correctAnswers, total: questionsAmount, date: Date())
        if let bestGameFromStore = statisticService?.bestGame {
            bestGame = bestGameFromStore
        }
        
        let message = """
Ваш результат: \(correctAnswers)/\(questionsAmount)
Количество сыгранных квизов: \(gamesCount.description)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", totalAccuracy))%
"""
        return message
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didFailToLoadImage(with error: Error) {
        viewController?.showNetworkingErrorWhenImageLoad(message: error.localizedDescription)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.showQuestion(quiz: viewModel)
        }
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.showNetworkingError(message: error.localizedDescription)
    }
    
    func showLoadingIndicator() {
        viewController?.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        viewController?.hideLoadingIndicator()
    }
}
