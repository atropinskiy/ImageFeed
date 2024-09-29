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
    
    private var lastLoadedPage: Int?
    
    // ...
    
    func fetchPhotosNextPage() {
        // ...
    }
}
