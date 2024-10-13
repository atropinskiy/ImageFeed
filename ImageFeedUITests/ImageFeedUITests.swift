//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by alex_tr on 01.08.2024.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.launch()
        sleep(10)

    }
}

