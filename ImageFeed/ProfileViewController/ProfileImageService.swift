import Foundation

struct UserResult: Codable {
    let profileImage: ImageSize
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct ImageSize: Codable {
    let small: String
    let medium: String
    let large: String
}

final class ProfileImageService {
    static var shared = ProfileImageService()
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private var lastUserName: String?
    private let urlSession = URLSession.shared
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    
    func fetchProfileImageURL(username: String, token: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        if let task = task, task.state == .running {
            if lastUserName == username {
                completion(.failure(NetworkError.duplicateRequest))
                return
            } else {
                task.cancel()
            }
        }
        lastUserName = username
        
        let request = makeRequest(username: username, token: token)
        
        let task = urlSession.objectTask(for: request) {[weak self] (result: Result<UserResult, Error>) in
            guard let self = self else {return}
            switch result {
            case .success(let profileImage):
                let profileImageURL = profileImage.profileImage.medium
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: ["URL": profileImageURL])
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastUserName = nil
            }
        }
        self.task = task
        task.resume()
    }
    
}

private func makeRequest(username: String, token: String) -> URLRequest {
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = "api.unsplash.com"
    urlComponents.path = "/users/\(username)"
    guard let url = urlComponents.url else {
        fatalError("URL error")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    return request
}

