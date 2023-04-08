//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Алия Давлетова on 06.04.2023.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        sleep(3)
        
        // находим первоначальный постер
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        // находим кнопку "Да" и нажимаем ее
        app.buttons["Yes"].tap()
        
        sleep(3)
        // еще раз находим постер
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexlabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexlabel.label, "2/10")
    }
    
    func testNoButton() throws {
        sleep(3)
        
        // находим первоначальный постер
        let firstPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        // находим кнопку "Нет" и нажимаем ее
        app.buttons["No"].tap()
        
        sleep(3)
        // еще раз находим постер
        let secondPosterData = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexlabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexlabel.label, "2/10")
    }
    
    func testFinishGame() throws {
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        sleep(3)
        
        let alert = app.alerts["Game over"]
        
        XCTAssert(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть еще раз")
    }
    
    func testTapButtonOnFinishAlert() throws {
        sleep(3)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(3)
        }
        sleep(3)
        
        let alert = app.alerts["Game over"]
        
        XCTAssert(alert.exists)
        
        alert.buttons.firstMatch.tap()
        
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        
        XCTAssert(firstPoster.exists)
        
        let indexlabel = app.staticTexts["Index"]
        
        XCTAssertEqual(indexlabel.label, "1/10")
    }
}
