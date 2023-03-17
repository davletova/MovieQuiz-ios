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
            guard let data = userDefaults.data(forKey: Keys.total.rawValue),
                  let record = try? JSONDecoder().decode(Double.self, from: data) else {
                return 0
            }
            
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.total.rawValue)
        }
    }
    
    // количество всех сыгранных квизов
    var gamesCount: Int {
        get {
            guard let data = userDefaults.data(forKey: Keys.gamesCount.rawValue),
                  let record = try? JSONDecoder().decode(Int.self, from: data) else {
                return 0
            }
            
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.gamesCount.rawValue)
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
        let totalCorrectAnswer: Int = count + Int(totalAccuracy) / 100 * gamesCount * questionsCountInGame

        // прибавляем к общему количеству игр пройденную игру
        gamesCount += 1

        // вычисляем новую точность ответов с учетом последней игры
        totalAccuracy = Double(totalCorrectAnswer / (gamesCount * questionsCountInGame) * 100)
        
        // сравниаем лучший результат игры с результатом последней игры
        // если результат последней игры лучше, то сохраняем его
        if count > bestGame.correct {
            let newbBestGame = GameRecord(correct: count, total: amount, date: Date())
            self.bestGame = newbBestGame
        }
    }
}
