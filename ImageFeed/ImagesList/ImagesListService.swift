//
//  ImageListService.swift
//  ImageFeed
//
//  Created by alex_tr on 29.09.2024.
//

import Foundation

final class ImagesListService {
    private (set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private var task: URLSessionTask?
    private var lastLoadedPage: Int?
    private let urlSession = URLSession.shared
    
    // ...
    
    func fetchPhotosNextPage(){
            assert(Thread.isMainThread)
            if task != nil {return}
            
            let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
            lastLoadedPage = nextPage
            
            let request = makeRequest(path: "/photos?page=\(nextPage)&&per_page=10")
            let task = urlSession.objectTask(for: request) {[weak self] (result: Result<[PhotoResult], Error>) in
                guard let self = self else {return}
                switch result {
                case .success(let photoResult):
                    self.preparePhoto(photoResult)
                    NotificationCenter.default.post(name: ImagesListService.DidChangeNotification, object: self, userInfo: ["photos" : self.photos] )
                    self.task = nil
                case .failure(let error):
                    self.task = nil
                    print(error)
                }
            }
            self.task = task
            task.resume()
        }
    
    private func makeRequest(path: String) -> URLRequest {
            
            guard let url = URL(string: path, relativeTo: DefaultBaseURL) else {fatalError("Failed to create URL for ImagesList")}
            guard let token = oAuth2TokenStorage.token else {fatalError("Failed to create Token")}
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            return request
        }
}
