import Foundation

final class ProfileService {
    private var lastCode: String?
    private var task: URLSessionTask?
    private let urlSession = URLSession.shared
    private(set) var profile: Profile?
    static var shared = ProfileService()
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        if let task = task, task.state == .running {
            if lastCode == token {
                completion(.failure(NetworkError.duplicateRequest))
                return
            } else {
                task.cancel()
            }
        }
        
        lastCode = token
        
        let request = makeRequest(token: token)
        
        let task = urlSession.dataTask(with: request) { [weak self] (data, response, error) in
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
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let profileResult = try decoder.decode(ProfileResult.self, from: data)
                let profile = Profile(result: profileResult)
                self.profile = profile
                completion(.success(profile))
            } catch {
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
        
    }
    

    
    private func makeRequest(token: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.unsplash.com"
        urlComponents.path = "/me"
        guard let url = urlComponents.url else {
            fatalError("URL error")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
