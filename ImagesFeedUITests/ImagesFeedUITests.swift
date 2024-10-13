//
//  ImagesFeedUITests.swift
//  ImagesFeedUITests
//
//  Created by alex_tr on 13.10.2024.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication() // переменная приложения
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        sleep(8)
        let webView = app.webViews["WebViewViewController"]
        XCTAssertTrue(webView.waitForExistence(timeout: 25))
        let passwordTextFiled = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextFiled.waitForExistence(timeout: 15))
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10))
        loginTextField.tap()
        loginTextField.typeText("vaskaop@mail.ru")
        sleep(2)
        app.tap()
        
       
        sleep(3)
        passwordTextFiled.tap()
        passwordTextFiled.typeText("Ghbdtnhtv2")
        app.tap()
        
        print(app.debugDescription)
        
        let loginButton = webView.descendants(matching: .button).element
        loginButton.tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
        
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        sleep(4)
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(8)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeBtn"].tap()
        sleep(8)
        cellToLike.buttons["likeBtn"].tap()
        
        sleep(8)
        cellToLike.tap()
        sleep(8)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["backBtn"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(2)
        XCTAssertTrue(app.staticTexts["Alex Tropinskiy"].exists)
        XCTAssertTrue(app.staticTexts["@vaskaop"].exists)
        
        app.buttons["logoutBtn"].tap()
        
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
