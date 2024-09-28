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
        
        task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                completion(.failure(NetworkError.requestCancelled))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let userResult = try JSONDecoder().decode(UserResult.self, from: data)
                let avatarURL = userResult.profileImage.small
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageService.didChangeNotification,
                        object: self,
                        userInfo: ["URL": avatarURL])
            } catch {
                completion(.failure(error))
            }
            
            self.task = nil
            self.lastUserName = nil
        }
        task?.resume()
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
}
