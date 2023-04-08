import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    private let presenter = MovieQuizPresenter()
     
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var statisticService: StatisticService? = StatisticServiceImplementation()
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        yesButton.isEnabled = false
        noButton.isEnabled = false
        
        presenter.yesButtonClicked()
}

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        presenter.noButtonClicked()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        presenter.viewController = self
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    
        showLoadingIndicator()
        
        questionFactory?.loadData()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        yesButton.isEnabled = true
        noButton.isEnabled = true
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.QuestionNumber
    }
    
    private func showAlert() {
        statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
        
        // пытаемся достать количество сыгранных квизов
        // если не получается, то считаем, что количество сыгранных квизов = 1
        var gamesCount = 1
        if let gamesCountFromStore = statisticService?.gamesCount {
            gamesCount = gamesCountFromStore
        }
        
        // пытаемся достать точность ответов за все игры
        // если не получается, то вычисляем точность на основе последней игры
        var totalAccuracy: Double = Double(correctAnswers / presenter.questionsAmount * 100)
        if let totalAccuracyFromStore = statisticService?.totalAccuracy {
            totalAccuracy =  totalAccuracyFromStore
        }
       
        // пытаемся достать лучшую игру
        // если не получается, то считаем, что лучшая игра - текущая
        var bestGame = GameRecord(correct: correctAnswers, total: presenter.questionsAmount, date: Date())
        if let bestGameFromStore = statisticService?.bestGame {
            bestGame = bestGameFromStore
        }
        
        let title = "Этот раунд окончен"
        let buttontext = "Сыграть еще раз"
        let message = """
Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
Количество сыгранных квизов: \(gamesCount.description)
Рекорд: \(bestGame.correct)/\(bestGame.total) (\(bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", totalAccuracy))%
"""
        let alertModel = AlertModel(title: title, message: message, buttonText: buttontext, identifier: "Game over")
        alertModel.completion = {
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter = AlertPresenter(delegate: self)
        
        alertPresenter?.present(model: alertModel)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        
        if isCorrect {
            self.correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor // делаем рамку зеленой
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor // делаем рамку красной
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // убираем зеленую или красную рамку после предыдущего ответа
            guard let self = self else { return }
            
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
           }
    }

    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            showAlert()
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showNetworkingError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: "Не удалось загрузить данные",
                                    buttonText: "Попробовать еще раз",
                                    identifier: "failed to load movies")
        alertModel.completion = {
            self.showLoadingIndicator()
            
            self.questionFactory?.loadData()
        }
        alertPresenter = AlertPresenter(delegate: self)
        
        alertPresenter?.present(model: alertModel)
    }
    
    private func showNetworkingErrorWhenImageLoad(message: String) {
        let alertModel = AlertModel(title: "Ошибка",
                                    message: "Не удалось загрузить фильм",
                                    buttonText: "Попробовать еще раз",
                                    identifier: "failed to load image")
        alertModel.completion = {
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter = AlertPresenter(delegate: self)
        
        alertPresenter?.present(model: alertModel)
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        // задаем цвет фон для лоадера для лучшего его отображения
        activityIndicator.backgroundColor = .lightGray.withAlphaComponent(0.5)
        // указываем цвет, так как настройка backgroundColor меняет цвет самого лоадера
        activityIndicator.color = .white
        //запускаем анимацию
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
}

// MARK: QuestionFactoryDelegate
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didFailToLoadImage(with error: Error) {
        showNetworkingErrorWhenImageLoad(message: error.localizedDescription)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkingError(message: error.localizedDescription)
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        presenter.currentQuestion = question
        let viewModel = presenter.convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
}
    
//MARK: AlertPresentDelegate
extension MovieQuizViewController: AlertPresentDelegate {
    func present(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
}

/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА


 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ


 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
