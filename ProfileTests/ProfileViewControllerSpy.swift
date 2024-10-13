//
//  ProfileViewControllerSpy.swift
//  ProfileTests
//
//  Created by alex_tr on 13.10.2024.
//

@testable import ImageFeed
import Foundation
import UIKit

final class ProfileViewControllerSpy: UIAlertAction, ProfileViewControllerProtocol {
    
    var presenter: ImageFeed.ProfilePresenterProtocol?
    var setAvatarCalls = false
    
    func updateAvatar() {
        setAvatarCalls = true
    }
    
    func updateRootViewControler() {
        
    }
    
    func createCanvas() {
        
    }
    
    func updateProfile(profile: ImageFeed.Profile?) {
        
    }
    
    func exitAlert(title: String, message: String, action: ((UIAlertAction) -> ())?) {
        
    }
    
    func cleanCookies() {
        
    }
    
    func switchToSplashScreen() {
        
    }
    
    func didTapLogOutButton() {
        
    }
    
    func alert(title: String, message: String, action: ((UIAlertAction) -> ())?) {
        
    }

    
}
