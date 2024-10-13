//
//  File.swift
//  ProfileTests
//
//  Created by alex_tr on 12.10.2024.
//

@testable import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    var view: ImageFeed.ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var logOutCalled: Bool = false
    
    func setNotificationObserver() {
        
    }
    
    func viewDidLoad(){
        viewDidLoadCalled = true
    }
    
    func logOut() {
        logOutCalled = true
    }
}
