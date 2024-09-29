import UIKit

final class SplashViewController: UIViewController {
    
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service.shared
    private let storage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addLogoToSplashscreen()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        storage.clearToken()
        
        if storage.token != nil {
            guard let token = storage.token else { return }
            fetchProfile(token)
        } else {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            guard let authViewController = storyBoard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else {return}
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            self.present(authViewController, animated: true)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
    //            guard
    //                let navigationController = segue.destination as? UINavigationController,
    //                let viewController = navigationController.viewControllers[0] as? AuthViewController
    //            else { fatalError("Can not find AuthViewController") }
    //            viewController.delegate = self
    //        } else {
    //            super.prepare(for: segue, sender: sender)
    //        }
    //    }
    
    private func addLogoToSplashscreen() {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "Image")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 75),
            logoImageView.heightAnchor.constraint(equalToConstant: 75)
        ])
        
    }
    
    private func switchToTabBarController() {
        DispatchQueue.main.async {
            print("Switching to TabBarController")
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
                return
            }
            print("Window is valid, proceeding...")
            let tabBarController = UIStoryboard(name: "Main", bundle: .main)
                .instantiateViewController(withIdentifier: "TabBarViewController")
            window.rootViewController = tabBarController
        }
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(code: String) {
        UIBlockingProgressHUD.show()
        oauth2Service.fetchAuthToken(code) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let accessToken):
                    self.storage.token = accessToken
                    self.fetchProfile(accessToken)
                    self.switchToTabBarController()
                    
                case .failure(let error):
                    print("Failed: \(error)")
                    break
                }
            }
        }
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        self.fetchAvatar(profile.username)
                    case .failure:
                        // TODO [Sprint 11] Покажите ошибку получения профиля
                        break
                    }
                }
            }
        }
    }
    
    private func fetchAvatar(_ username: String) {
        guard let token = storage.token else {
            print("No token available")
            return
        }
        
        profileImageService.fetchProfileImageURL(username: username, token: token) { result in
            switch result {
            case .success(let avatarURL):
                print("Avatar URL: \(avatarURL)")
            case .failure(let error):
                print("Failed to fetch avatar: \(error)")
            }
        }
        
        self.switchToTabBarController()
    }
    
}
