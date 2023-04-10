//
//  DateTests.swift
//  MovieQuizTests
//
//  Created by Алия Давлетова on 10.04.2023.
//

import XCTest
@testable import MovieQuiz

final class DateTests: XCTestCase {
    func testDateTimeDefaultFormatterTests() throws {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        guard let date = dtFormatter.date(from: "2018-02-01T19:10:04") else {
            XCTFail("failed to parse date")
            return
        }
        
        XCTAssertEqual(date.dateTimeString, "01.02.18 07:10")
    }
}
