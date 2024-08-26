import Foundation

enum Constants {
    static let accessKey = "vUws_PCNLBerfwk8zOql4f8D8LjaxIXEs2n1IaeOx3Y"
    static let secretKey = "NpdDyOExDbpx6MCA3LRDMZI8Bh02JQ1x39_yogr0fNQ"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL = URL(string: "https://api.unsplash.com") // Я знаю что строка корректная, поэтому не вижу смысла делать unwrap тут
}
