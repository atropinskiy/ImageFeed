//
//  ImagesListPresenter.swift
//  ImageFeed
//
//  Created by alex_tr on 13.10.2024.
//

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? {get set}
    var photos: [Photo] {get}
    func viewDidLoad()
    func likeClick(indexPath: IndexPath)
    func updateNextPagePhotos(forRowAt indexPath: IndexPath)
}

import Foundation

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var imagesListServiceObserver: NSObjectProtocol?
    private var imagesListService = ImagesListService.shared
    private(set) var photos: [Photo] = []
    
    init(view: ImagesListViewControllerProtocol) {
        self.view = view
    }
    
    func viewDidLoad(){
        
        UIBlockingProgressHUD.show()
        setNotificationObserver()
        imagesListService.fetchPhotosNextPage()
        print(123)
    }
    
    func setNotificationObserver() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                print("Received notification to update table view") // Логирование получения уведомления
                self.updateTableViewAnimated()
                UIBlockingProgressHUD.dismiss()
            }
    }
    
    func updateNextPagePhotos(forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func updateTableViewAnimated() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let oldCount = self.photos.count
            let newPhotos = self.imagesListService.photos
            let newCount = newPhotos.count
            if oldCount != newCount {
                self.photos = newPhotos // Обновляем массив
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                self.view?.didReceivePhotosForUpdate(at: indexPaths, new: self.photos)
            }
        }
    }
    
    func likeClick (indexPath: IndexPath){
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLikes(photoID: photo.id, isLike: !photo.isLiked) { [weak self]  result in
            guard let self = self else {return}
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.view?.isLike(indexPath: indexPath, isOn: self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
                
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.view?.showLikeAlert(with: error)
            }
        }
        
    }
}
