//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Алия Давлетова on 16.03.2023.
//

import Foundation

// количество вопросов в одном квизе
private let questionsCountInGame = 10

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    private let userDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    // средняя точность правильных ответов
    var totalAccuracy: Double {
        get {
            return userDefaults.double(forKey: Keys.total.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    // количество всех сыгранных квизов
    var gamesCount: Int {
        get {
            return userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    // результаты лучшей игры
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return GameRecord.init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int) {
        // вычисляем количество верных ответов за все сыгранные игры
        // необходимо для вычисления нового занчения totalAccuracy
        // прибавляем верные ответы из последней игры к общему количеству верных ответов
        let totalCorrectAnswer: Double = Double(count) + totalAccuracy / 100 * Double(gamesCount) * Double(questionsCountInGame)
        
        // прибавляем к общему количеству игр пройденную игру
        gamesCount += 1

        // вычисляем новую точность ответов с учетом последней игры
        totalAccuracy = totalCorrectAnswer * 100 / Double(gamesCount * questionsCountInGame)

        
        // сравниаем лучший результат игры с результатом последней игры
        // если результат последней игры лучше, то сохраняем его
        if count > bestGame.correct {
            let newBestGame = GameRecord(correct: count, total: amount, date: Date())
            bestGame = newBestGame
        }
    }
}
