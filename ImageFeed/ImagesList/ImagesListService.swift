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
            let date: Date? = {
                if let createdAtString = item.createdAt {
                    return dateFormatter.date(from: createdAtString)
                }
                return nil
            }()
            print("Received photo URL: \(item.urls.thumb)")
            return Photo(
                id: item.id,
                size: CGSize(width: item.width, height: item.height),
                createdAt: date,
                welcomeDescription: item.description,
                thumbImageURL: URL(string: item.urls.thumb),
                fullImageURL: URL(string:item.urls.full),
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
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        print("Fetching photos for page: \(nextPage)") // Логирование текущей страницы
        
        let request = makeRequest(path: "/photos?page=\(nextPage)&per_page=10")
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResult):
                print("Successfully fetched \(photoResult.count) photos") // Логирование количества загруженных фото
                self.preparePhoto(photoResult)
                lastLoadedPage = nextPage
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
    
    func changeLikes(photoID: String, isLike: Bool, _ completion: @escaping(Result<Void, Error>) -> Void) {
        guard let token = oAuth2TokenStorage.token else {
            fatalError("Bad token")
        }
        
        // Определяем HTTP метод (POST для добавления лайка, DELETE для удаления)
        let method = isLike ? "POST" : "DELETE"
        
        // Логирование процесса изменения лайка
        print("Changing like for photoID: \(photoID), current state: \(isLike ? "Like" : "Unlike")")
        
        
        var request = URLRequest.makeHTTPRequest(
            path: "/photos/\(photoID)/like",
            httpMethod: method,
            baseURL: Constants.defaultBaseURL
        )
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Запуск задачи на сервере
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<Liked, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                print("Successfully changed like for photoID: \(photoID)")
                
                // Обновляем локально только при успешной операции
                if let index = self.photos.firstIndex(where: { $0.id == photoID }) {
                    self.photos[index].isLiked.toggle() // Просто переключаем значение
                    print("Updated photo in local data. New like status: \(self.photos[index].isLiked)")
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self) // Уведомляем об изменении
                }
                completion(.success(()))
                
            case .failure(let error):
                print("Failed to change like for photoID: \(photoID), error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
        
        // Запускаем задачу
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
