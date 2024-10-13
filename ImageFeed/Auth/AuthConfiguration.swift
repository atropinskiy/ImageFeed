//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by alex_tr on 12.10.2024.
//

import Foundation

enum Constants {
    static let accessKey = "vUws_PCNLBerfwk8zOql4f8D8LjaxIXEs2n1IaeOx3Y"
    static let secretKey = "NpdDyOExDbpx6MCA3LRDMZI8Bh02JQ1x39_yogr0fNQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let UnsplashAuthorizeURLString: String
    let defaultBaseURL: URL

    // Инициализатор без ненужных параметров
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, defaultBaseURL: URL, UnsplashAuthorizeURLString: String) {
        self.accessKey = Constants.accessKey
        self.secretKey = Constants.secretKey
        self.redirectURI = Constants.redirectURI
        self.accessScope = Constants.accessScope
        self.UnsplashAuthorizeURLString = Constants.UnsplashAuthorizeURLString
        self.defaultBaseURL = Constants.defaultBaseURL
    }

    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 defaultBaseURL: Constants.defaultBaseURL,
                                 UnsplashAuthorizeURLString: Constants.UnsplashAuthorizeURLString)
    }
}
