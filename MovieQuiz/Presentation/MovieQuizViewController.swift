import UIKit

final class MovieQuizViewController: UIViewController {
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        isEnabledButtons(false)
        presenter.yesButtonClicked()
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        isEnabledButtons(false)
        presenter.noButtonClicked()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self, statisticService: StatisticServiceImplementation())
        alertPresenter = AlertPresenter(delegate: self)
        
        showLoadingIndicator()
    }
    
    private func isEnabledButtons(_ isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
}
    
//MARK: MovieQuizViewControllerProtocol
extension MovieQuizViewController: MovieQuizViewControllerProtocol {
    func showQuestion(quiz step: QuizStepViewModel) {
        isEnabledButtons(true)
        
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.QuestionNumber
    }
    
    func showGameOverAlert() {
        let message = presenter.makeResultMessage()
        let alertModel = AlertModel(title: "Этот раунд окончен",
                                    message: message,
                                    buttonText: "Сыграть еще раз",
                                    identifier: "Game over")
        alertModel.completion = {
            self.presenter.restartGame()
            self.presenter.requestNextQuestion()
        }
        
        alertPresenter?.present(model: alertModel)
    }
    
    func showNetworkingError(message: String) {
        hideLoadingIndicator()
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: "Не удалось загрузить данные",
                                    buttonText: "Попробовать еще раз",
                                    identifier: "failed to load movies")
        alertModel.completion = {
            self.showLoadingIndicator()
            self.presenter.loadData()
        }
        
        alertPresenter?.present(model: alertModel)
    }
    
    func showNetworkingErrorWhenImageLoad(message: String) {
        let alertModel = AlertModel(title: "Ошибка",
                                    message: "Не удалось загрузить фильм",
                                    buttonText: "Попробовать еще раз",
                                    identifier: "failed to load image")
        alertModel.completion = {
            self.presenter.requestNextQuestion()
        }
        
        alertPresenter?.present(model: alertModel)
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    func disableImageBorder() {
        imageView.layer.borderWidth = 0
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
