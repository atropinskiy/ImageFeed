//
//  ImageListModels.swift
//  ImageFeed
//
//  Created by alex_tr on 29.09.2024.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
