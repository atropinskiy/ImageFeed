//
//  ImagesListPresenterSpy.swift
//  ImagesListTests
//
//  Created by alex_tr on 13.10.2024.
//

@testable import ImageFeed
import Foundation

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var photos: [ImageFeed.Photo] = []
    var view: ImageFeed.ImagesListViewControllerProtocol?
    func likeClick(indexPath: IndexPath) {
    }
    
    func updateNextPagePhotos(forRowAt indexPath: IndexPath) {
    }
    var viewDidLoadCalled: Bool = false
    var updateNextPageIfNeededCalled: Bool = false

    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateNextPageIfNeeded(forRowAt indexPath: IndexPath) {
         updateNextPageIfNeededCalled = true
    }
}
