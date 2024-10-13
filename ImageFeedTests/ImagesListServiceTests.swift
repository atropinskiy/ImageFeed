//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by alex_tr on 01.08.2024.
//

import XCTest
@testable import ImageFeed

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        var notificationReceived = false // Флаг для проверки, что уведомление получено

        let observer = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                if !notificationReceived {
                    notificationReceived = true
                    expectation.fulfill() // Выполняем ожидание только один раз
                }
            }
        
        service.fetchPhotosNextPage()
        
        // Обязательно удалите наблюдателя после теста
        defer {
            NotificationCenter.default.removeObserver(observer)
        }
        
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "WebViewViewController") as! WebViewViewController
    }
}
