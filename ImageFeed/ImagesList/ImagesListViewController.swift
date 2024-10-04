import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private(set) var photos : [Photo] = []
    
    @IBOutlet var tableView: UITableView!
    private let imagesListService = ImagesListService.shared
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        UIBlockingProgressHUD.show()
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                print("Received notification to update table view") // Логирование получения уведомления
                self.updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.tintColor = UIColor.ypWhite // Цвет выбранного элемента
            tabBar.barTintColor = UIColor.black // Цвет невыбранных элементов
        }
        imagesListService.fetchPhotosNextPage()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let fullImageURL = URL(string: photos[indexPath.row].fullImageURL)
            viewController.fullImageURL = fullImageURL
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func updateTableViewAnimated() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let oldCount = photos.count
            self.photos = imagesListService.photos
            let newCount = self.photos.count
            print("Old count: \(oldCount), New count: \(newCount)") // Логирование количества строк
            print("Updated photos: \(self.photos)") // Логирование обновленных данных
            if oldCount != newCount {
                self.tableView.reloadData() // Принудительная перезагрузка таблицы
            }
        }
    }
    private func showLikeAlert(with error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так",
            message: "Действие временно недоступно, попробуйте позднее",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row] // Получаем текущую фотографию
        print("Configuring cell for index \(indexPath.row), photo ID: \(photo.id), thumbURL: \(photo.thumbImageURL)")
        guard let thumbURL = URL(string: photo.thumbImageURL), // Используем свойство thumbImageURL
              let placeholder = UIImage(named: "Stub") else { return }
        
        cell.cellImage.kf.indicatorType = .activity // Устанавливаем индикатор загрузки
        cell.cellImage.kf.setImage(with: thumbURL, placeholder: placeholder, options: [
            .transition(.fade(0.2)), // Плавный переход при загрузке изображения
            .cacheOriginalImage // Кеширование оригинального изображения
        ])
        
        cell.setIsLiked(isLiked: photo.isLiked)
        
        if let date = photo.createdAt {
            print("DATATATATATA", date)
            cell.dateLabel.text = dateFormatter.string(from: date)
            print("Date label set to: \(cell.dateLabel.text ?? "")")
        } else {
            cell.dateLabel.text = nil
            print("Date label cleared")
        }
    }
}



extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
}



