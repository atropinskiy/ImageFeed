import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? {get set}
    func didReceivePhotosForUpdate(at indexPath: [IndexPath], new array: [Photo])
    func isLike(indexPath: IndexPath, isOn: Bool)
    func showLikeAlert(with: Error)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var imagesListServiceObserver: NSObjectProtocol?
    private(set) var photos : [Photo] = []
    var presenter: ImagesListPresenterProtocol?
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
        presenter = ImagesListPresenter(view: self)
        presenter?.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let fullImageURL = photos[indexPath.row].fullImageURL
            viewController.fullImageURL = fullImageURL
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func isLike(indexPath: IndexPath, isOn: Bool) {
        UIBlockingProgressHUD.dismiss()
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else {return}
        cell.setIsLiked(isLiked: isOn)
    }
    
    func showLikeAlert(with error: Error) {
        UIBlockingProgressHUD.dismiss()
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
        
        configureImage(for: cell, with: photo)
        cell.setIsLiked(isLiked: photo.isLiked)
        cell.delegate = self
        
        cell.dateLabel.text = photo.createdAt.map { dateFormatter.string(from: $0) } ?? nil
        print("Date label set to: \(cell.dateLabel.text ?? "nil")")
    }
    
    private func configureImage(for cell: ImagesListCell, with photo: Photo) {
        guard let thumbURL = photo.thumbImageURL,
              let placeholder = UIImage(named: "Stub") else { return }
        
        cell.cellImage.kf.indicatorType = .activity // Устанавливаем индикатор загрузки
        cell.cellImage.kf.setImage(with: thumbURL,
                                   placeholder: placeholder,
                                   options: [
                                    .transition(.fade(0.2)), // Плавный переход при загрузке изображения
                                    .cacheOriginalImage      // Кеширование оригинального изображения
                                   ])
    }
    
    func didReceivePhotosForUpdate(at indexPath: [IndexPath], new array: [Photo]) {
        print("Before update: \(photos.count) photos")
        self.photos = array
        print("After update: \(photos.count) photos")
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPath, with: .automatic)
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

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {return}
        UIBlockingProgressHUD.show()
        presenter?.likeClick(indexPath: indexPath)
    }
}


