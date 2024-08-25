import UIKit

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
}

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init () {}
    
    private var task: URLSessionTask?
    private var lastCode: String?
    
    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        guard let request = makeRequest(code) else {
            completion(.failure(NetworkError.urlRequestError(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))))
            return
        }
        getUnsplashToken(request: request) { (result: Result<Data, Error>)  in
            let parsed = result.flatMap { data -> Result<String, Error> in
                 do {
                     let responseBody = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                     return .success(responseBody.accessToken)
                 } catch {
                     print("Failed to decode OAuthTokenResponseBody: \(error.localizedDescription)")
                     print("Received data: \(String(data: data, encoding: .utf8) ?? "nil")")
                     return .failure(error)
                 }
             }
             completion(parsed)
        }
    }
    
    private func makeRequest(_ code: String) -> URLRequest? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "unsplash.com"
        urlComponents.path = "/oauth/token"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            print("URL error")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    func getUnsplashToken(
        request: URLRequest,
        responseHandler: @escaping (Result<Data, Error>) -> Void
    ) {
        let resultCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                responseHandler(result)
            }
        }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                resultCompletion(.failure(NetworkError.urlRequestError(error)))
            }
            if let responseCode = (response as? HTTPURLResponse)?.statusCode {
                print(responseCode)
                if 200..<300 ~= responseCode {
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Server Response JSON: \(jsonString)")
                        }
                        resultCompletion(.success(data))
                    }
                } else {
                    resultCompletion(.failure(NetworkError.httpStatusCode(responseCode)))
                }
            }
            if let data = data {
                resultCompletion(.success(data))
            }
        }
        task.resume()
    }
}
