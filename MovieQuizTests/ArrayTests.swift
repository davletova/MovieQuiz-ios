//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Алия Давлетова on 06.04.2023.
//

import Foundation

import XCTest
@testable import MovieQuiz

class ArrayTests: XCTestCase {
    // тест на успешное взятие элемента по индексу
    func testGetValueInRange() throws {
        let array = [1, 2, 3, 4, 5]
        
        let value = array[safe: 2]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 3)
    }
    
    // тест на вязтие элемента по неправильному индексу
    func testGetValueOutOfRange() throws {
        let array = [1, 2, 3, 4, 5]
        
        let value = array[safe: 6]
        
        XCTAssertNil(value)
    }
}
