import UIKit
import Kingfisher


final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileLogoutService = ProfileLogoutService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    private let nameLabel = UILabel()
    private let nickLabel = UILabel()
    private let messageLabel = UILabel()
    private let tokenStorage = OAuth2TokenStorage()
    private let avatarImageView = UIImageView()
    private var logoutButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(named: "Exit")!, target: self, action: #selector(didTapLogOutButton))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .red
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCanvas()
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateAvatar()                                 // 6
            }
        updateProfile(profile: profileService.profile)
        updateAvatar()
    }
    
    func createCanvas() {
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
    private func updateProfile(profile: Profile?) {
        guard let profile = profile else { return }
        self.nameLabel.text = profile.name
        self.nickLabel.text = profile.loginName
        self.messageLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL) else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 35)
        print(profileImageURL)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "Placeholder"),
                                    options: [.processor(processor),.cacheSerializer(FormatIndicatedCacheSerializer.png)])
        let cache = ImageCache.default
        cache.clearDiskCache()
        cache.clearMemoryCache()
    }
    
    @objc
    private func didTapLogOutButton() {
        profileLogoutService.logout()
    }
    
}
