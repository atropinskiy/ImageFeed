import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCanvas()
    }
    
    func createCanvas() {
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "MockUserPhoto") // Установите имя вашего изображения
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = .ypWhite
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let nickLabel = UILabel()
        nickLabel.text = "@ekaterina_nov"
        nickLabel.textColor = .ypGray
        nickLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nickLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let messageLabel = UILabel()
        messageLabel.text = "Hello, world!"
        messageLabel.textColor = .ypWhite
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let exitButton = UIButton()
        exitButton.setImage(UIImage(named: "Exit"), for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exitButton)
        view.addSubview(nameLabel)
        view.addSubview(nickLabel)
        view.addSubview(messageLabel)
        
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        NSLayoutConstraint.activate([
            // Ограничения для imageView
            exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            
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
}
