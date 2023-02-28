import UIKit

final class MovieQuizViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstQuestion = self.questions[self.currentQuestionIndex]
        let viewModel = self.convert(model: firstQuestion)
        self.show(quiz: viewModel)
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!

    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = true
        return showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }

    @IBAction private func noButtonClicked(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let givenAnswer = false
        return showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
        
        init(_ image: String, _ text: String, _ correctAnswer: Bool) {
            self.image = image
            self.text = text
            self.correctAnswer = correctAnswer
        }
    }
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let QuestionNumber: String
    }
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    private let questions: [QuizQuestion] = [
        QuizQuestion("The Godfather", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("The Dark Knight", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("Kill Bill", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("The Avengers", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("Deadpool", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("The Green Knight", "Рейтинг этого фильма больше чем 6?", true),
        QuizQuestion("Old", "Рейтинг этого фильма больше чем 6?", false),
        QuizQuestion("The Ice Age Adventures of Buck Wild", "Рейтинг этого фильма больше чем 6?", false),
        QuizQuestion("Tesla", "Рейтинг этого фильма больше чем 6?", false),
        QuizQuestion("Vivarium", "Рейтинг этого фильма больше чем 6?", false),
    ]
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = "\(step.QuestionNumber)/10"
    }

    private func show(qiuz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title, message: result.text, preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть еще раз", style: .default) {_ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            // заново показываем первый вопрос
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
        }
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true // даём разрешение на рисование рамки
        imageView.layer.borderWidth = 8 // толщина рамки
        // imageView.layer.cornerRadius = 20 // радиус скругления углов рамки
        
        if isCorrect {
            self.correctAnswers += 1
            imageView.layer.borderColor = UIColor.ypGreen.cgColor // делаем рамку зеленой
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor // делаем рамку красной
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // убираем зеленую или красную рамку после предыдущего ответа
            self.imageView.layer.borderWidth = 0
            
               self.showNextQuestionOrResults()
           }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let resultText = "Ваш результат:\(self.correctAnswers)/\(self.questions.count)"
            let result = QuizResultsViewModel(title: "Этот раунд окончен", text: resultText, buttonText: "Сыграть еще раз")
                
            self.show(qiuz: result)
        } else {
            currentQuestionIndex += 1
            
            let nextQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: nextQuestion)
            self.show(quiz: viewModel)
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            QuestionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
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
