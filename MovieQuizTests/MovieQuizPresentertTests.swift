//
//  MovieQuizPresenter.swift
//  MovieQuizTests
//
//  Created by Алия Давлетова on 09.04.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showQuestion(quiz: MovieQuiz.QuizStepViewModel) {}
    
    func showGameOverAlert() {}
    
    func showNetworkingErrorWhenImageLoad(message: String) {}
    
    func showNetworkingError(message: String) {}
    
    func highlightImageBorder(isCorrectAnswer: Bool) {}
    
    func disableImageBorder() {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresentConvertModel() throws {
        let viewControlMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControlMock, statisticService: StatisticServiceImplementation())
        
        let emptyData = Data()
        let question = QuizQuestion(emptyData, "Question text", true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, question.text)
        XCTAssertEqual(viewModel.QuestionNumber, "1/10")
    }
    
    func testPresenter() throws {
        let viewControlMock = MovieQuizViewControllerMock()
        
        class StatisticServiceMock: StatisticService {
            var totalAccuracy: Double
            var gamesCount: Int
            var bestGame: GameRecord
            
            func store(correct count: Int, total amount: Int) {}
            
            init(totalAccuracy: Double, gamesCount: Int, bestGame: GameRecord) {
                self.totalAccuracy = totalAccuracy
                self.gamesCount = gamesCount
                self.bestGame = bestGame
            }
        }
        let totalAccuracy = 60.0
        let gamesCount = 10
        let bestGameDate = Date(timeIntervalSince1970: 5)
        let bestGame = GameRecord(correct: 5, total: 10, date: bestGameDate)
        let statisticServiceMock = StatisticServiceMock(totalAccuracy: totalAccuracy,
                                                        gamesCount: gamesCount,
                                                        bestGame: bestGame
        )
        
        let sut = MovieQuizPresenter(viewController: viewControlMock, statisticService: statisticServiceMock)
        
        let actualresultMsg = sut.makeResultMessage()
        
        let expectedResultMsg = """
Ваш результат: 0/10
Количество сыгранных квизов: \(gamesCount.description)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", totalAccuracy))%
"""
        
        XCTAssertEqual(actualresultMsg, expectedResultMsg)
    }
}
