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

struct PhotoResult: Codable {
    let id: String
    let createdAt: String
    let width, height: Int
    let likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: UrlsResult
    
    struct UrlsResult: Codable {
        let raw, full, regular, small: String
        let thumb: String
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height
        case likes
        case likedByUser = "liked_by_user"
        case description
        case urls
    }
}
