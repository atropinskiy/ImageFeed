//
//  ProfileTests.swift
//  ProfileTests
//
//  Created by alex_tr on 12.10.2024.
//

import XCTest
@testable import ImageFeed

final class ProfileTests: XCTestCase {

    func testViewControllerCallsViewDidLoad(){
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        
        viewController.presenter = presenter
        presenter.view = viewController
        
        // when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testProfileViewCallsLogout() {
        let viewController = ProfileViewControllerSpy()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        // When
        presenter.logOut()
        
        XCTAssertTrue(presenter.logOutCalled)
    }
}
