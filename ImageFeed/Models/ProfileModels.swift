//
//  ProfileModels.swift
//  ImageFeed
//
//  Created by alex_tr on 29.09.2024.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
}

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(result: ProfileResult) {
        self.username = result.username
        self.name = "\(result.firstName)" + " " + "\(result.lastName)"
        self.loginName = "@\(result.username)"
        self.bio = result.bio
    }
}
