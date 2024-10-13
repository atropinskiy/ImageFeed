//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by alex_tr on 12.10.2024.
//

import UIKit

protocol ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol? {get set}
    func logOut()
    func viewDidLoad()
    func setNotificationObserver()
}


final class ProfilePresenter: ProfilePresenterProtocol  {
    weak var view: ProfileViewControllerProtocol?
    private let profileService = ProfileService.shared
    private var profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let storage = OAuth2TokenStorage.shared
    
    init(view: ProfileViewControllerProtocol) {
            self.view = view
        }
    
    func viewDidLoad() {
        print("View is set: \(view != nil)")
        view?.createCanvas()
        view?.updateProfile(profile: profileService.profile)
        view?.updateAvatar()
        setNotificationObserver()
    }
    
    func setNotificationObserver() {
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self?.view  else { return }
                self.updateAvatar()
            }
        guard let view = view else {return}
        view.updateAvatar()
    }
    
    func logOut(){
        view?.exitAlert(title: "Пока, пока!", message: "Уверены что хотите выйти", action: { [weak self] _ in
            guard let self = self else { return }
            self.storage.clearToken()
            view?.cleanCookies()
            view?.switchToSplashScreen()
            
        })
   }
    

    
}
