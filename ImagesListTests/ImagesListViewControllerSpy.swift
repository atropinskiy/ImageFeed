//
//  ImagesListViewControllerSpy.swift
//  ImagesListTests
//
//  Created by alex_tr on 13.10.2024.
//

import Foundation
@testable import ImageFeed

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    var photos: [Photo]
    
    init(photos: [Photo]) {
        self.photos = photos
    }
    
    func isLike(indexPath: IndexPath, isOn: Bool) {
        
    }
    
    func showLikeAlert(with: Error) {
        
    }
    
    func didReceivePhotosForUpdate(at indexPath: [IndexPath], new array: [ImageFeed.Photo]) {
        
    }
}
