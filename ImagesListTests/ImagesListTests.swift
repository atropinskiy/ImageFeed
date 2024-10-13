//
//  ImagesListTests.swift
//  ImagesListTests
//
//  Created by alex_tr on 13.10.2024.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {

    func testViewControllerCallsViewDidLoad() {
        let storyBoard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ImagesListViewController") as! ImagesListViewController
        let presenter = ImagesListPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        presenter.viewDidLoad()
        
        XCTAssertTrue(presenter.viewDidLoadCalled, "viewDidLoad не был вызван у presenter")
    }
    
    func testLikes(){
        let photo: [Photo] = []
        let view = ImagesListViewControllerSpy(photos: photo)
        let presenter = ImagesListPresenterSpy()
        view.presenter = presenter
        presenter.view = view
        
    }
}
