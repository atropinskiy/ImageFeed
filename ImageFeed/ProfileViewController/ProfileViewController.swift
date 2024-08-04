import UIKit

final class ProfileViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createCanvas()
    }
    
}

extension ProfileViewController {
    
    func createCanvas() {
        // Создаем UIImageView
        let imageView = UIImageView()
        imageView.image = UIImage(named: "MockUserPhoto") // Установите имя вашего изображения
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Создаем UILabel
        let label1 = UILabel()
        let label2 = UILabel()
        let label3 = UILabel()
        let exitButton = UIButton()
        
        // Настройки для кнопки
        exitButton.setImage(UIImage(named: "Exit"), for: .normal)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        
        // Устанавливаем текст для меток
        label1.text = "Екатерина Новикова"
        label2.text = "@ekaterina_nov"
        label3.text = "Hello, world!"
        
        // Устанавливаем цвет текста для меток
        label1.textColor = .ypWhite
        label2.textColor = .ypGray
        label3.textColor = .ypWhite
        
        // Размеры
        label1.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        // Отключаем autoresizing mask для использования Auto Layout
        label1.translatesAutoresizingMaskIntoConstraints = false
        label2.translatesAutoresizingMaskIntoConstraints = false
        label3.translatesAutoresizingMaskIntoConstraints = false
        
        // Добавляем метки в основной view
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        
        imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        NSLayoutConstraint.activate([
            // Ограничения для imageView
            exitButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Ограничения для label1
            label1.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Ограничения для label2
            label2.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 8),
            label2.leadingAnchor.constraint(equalTo: label1.leadingAnchor),
            
            // Ограничения для label3
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 22),
            label3.leadingAnchor.constraint(equalTo: label1.leadingAnchor),
        ])
    }
}
