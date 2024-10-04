//
//  ImageListService.swift
//  ImageFeed
//
//  Created by alex_tr on 29.09.2024.
//

import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    private let dateFormatter = ISO8601DateFormatter()
    
    func preparePhoto(_ photoResult: [PhotoResult]) {
        let newPhotos = photoResult.map { item in
            // Логирование URL изображений
            print("Received photo URL: \(item.urls.thumb)")
            return Photo(
                id: item.id,
                size: CGSize(width: item.width, height: item.height), // Здесь у вас должен быть правильный размер
                createdAt: dateFormatter.date(from: item.createdAt),
                welcomeDescription: item.description,
                thumbImageURL: item.urls.thumb,
                fullImageURL: item.urls.full,
                isLiked: item.likedByUser
            )
        }
        self.photos.append(contentsOf: newPhotos)
        print("Total photos after fetch: \(self.photos.count)")
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
    }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }

        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        
        print("Fetching photos for page: \(nextPage)") // Логирование текущей страницы

        let request = makeRequest(path: "/photos?page=\(nextPage)&per_page=10")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }

            switch result {
            case .success(let photoResult):
                print("Successfully fetched \(photoResult.count) photos") // Логирование количества загруженных фото
                self.preparePhoto(photoResult)
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                print("Notification posted")
                self.task = nil
            case .failure(let error):
                print("Failed to fetch photos: \(error.localizedDescription)") // Логирование ошибки
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    func changeLikes(photoID: String, isLike: Bool, _ completion: @escaping(Result<Void, Error>) -> Void){
        
        guard let token = oAuth2TokenStorage.token  else {fatalError("Failed to create Token")}
        let method = isLike ?  "DELETE" : "POST"
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoID)/like",
            httpMethod: method,
            baseURL: Constants.defaultBaseURL!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<Liked, Error>)in
            guard let self = self else {return}
            switch result {
            case .success(_):
                if let index = self.photos.firstIndex(where: {$0.id == photoID}) {
                    let photo = self.photos[index]
                    let newPhoto = Photo(id: photo.id, size: photo.size, createdAt: photo.createdAt, welcomeDescription: photo.welcomeDescription, thumbImageURL: photo.thumbImageURL, fullImageURL: photo.fullImageURL, isLiked: !photo.isLiked)
                    self.photos[index] = newPhoto
                }
                completion (.success(()))
            case .failure(let error):
                completion (.failure(error))
            }
        }
        task.resume()
    }
    
    private func makeRequest(path: String) -> URLRequest {
        
        guard let url = URL(string: path, relativeTo: Constants.defaultBaseURL) else {fatalError("Failed to create URL for ImagesList")}
        guard let token = oAuth2TokenStorage.token else {fatalError("Failed to create Token")}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
