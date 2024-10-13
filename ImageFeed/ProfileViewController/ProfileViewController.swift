import UIKit
import Kingfisher
import WebKit

protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfilePresenterProtocol? {get set}
    
    func updateAvatar()
    func didTapLogOutButton()
    func createCanvas()
    func updateProfile(profile: Profile?)
    func updateRootViewControler()
    func exitAlert(title: String, message: String, action: ((UIAlertAction) -> ())?)
    func cleanCookies()
    func switchToSplashScreen()
    
}

final class ProfileViewController: UIViewController, ProfileViewControllerProtocol {
    
    private let storage = OAuth2TokenStorage.shared
    var presenter: ProfilePresenterProtocol?
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let nameLabel = UILabel()
    private let nickLabel = UILabel()
    private let messageLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "Exit")!, target: nil, action: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.accessibilityIdentifier = "logoutBtn"
        presenter = ProfilePresenter(view: self)
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.backgroundColor = .ypBlack
        logoutButton.addTarget(self, action: #selector(didTapLogOutButton), for: .touchUpInside)
    }
    
    func updateProfile(profile: Profile?) {
        guard let profile = profile else { return }
        self.nameLabel.text = profile.name
        self.nickLabel.text = profile.loginName
        self.messageLabel.text = profile.bio
    }
    
    func updateAvatar() {
        // Получаем avatarURL из ProfileImageService
        guard let profileImageURL = ProfileImageService.shared.avatarURL,
              let url = URL(string: profileImageURL) else {
            print("Avatar URL is nil or invalid")
            return
        }

        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        print("Fetching avatar from URL: \(url)")
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url,
                                     placeholder: UIImage(named: "Placeholder"),
                                     options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
    
    func switchToSplashScreen() {
        // Получаем текущее окно приложения
        guard let window = UIApplication.shared.windows.first else {
            print("Не удалось получить главное окно.")
            return
        }
        
        // Создаем экземпляр SplashViewController программно
        let splashViewController = SplashViewController()
        
        // Устанавливаем его как rootViewController с анимацией
        window.rootViewController = splashViewController
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
    
    func createCanvas() {
        view.backgroundColor = .ypBlack
        avatarImageView.image = UIImage(named: "MockUserPhoto")
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nickLabel.text = "@ekaterina_nov"
        nickLabel.textColor = .ypGray
        nickLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nickLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.text = "Hello, world!"
        messageLabel.textColor = .ypWhite
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(logoutButton)
        view.addSubview(nameLabel)
        view.addSubview(nickLabel)
        view.addSubview(messageLabel)
        
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        NSLayoutConstraint.activate([
            // Ограничения для imageView
            
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Ограничения для nameLabel
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Ограничения для nickLabel
            nickLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nickLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            // Ограничения для messageLabel
            messageLabel.topAnchor.constraint(equalTo: nickLabel.bottomAnchor, constant: 22),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
        ])
    }
    
    func cleanCookies() {
        // Очищаем все куки из хранилища
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            // Массив полученных записей удаляем из хранилища
            records.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func exitAlert(title: String, message: String, action: ((UIAlertAction) -> ())?) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "Да", style: .default, handler: action)
        let cancelAction = UIAlertAction(title: "Нет", style: .cancel, handler: nil)
        alert.addAction(action)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc
    func didTapLogOutButton() {
        presenter?.logOut()
    }
}

extension ProfileViewController {
    func updateRootViewControler() {
        guard let window = UIApplication.shared.windows.first else {fatalError("Invalid Configuration")}
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
}
